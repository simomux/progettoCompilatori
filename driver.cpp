#include "driver.hpp"
#include "parser.hpp"


LLVMContext *context = new LLVMContext;
Module *module = new Module("Kaleidoscope", *context);
IRBuilder<> *builder = new IRBuilder(*context);

Value *LogErrorV(const std::string Str) {
  std::cerr << Str << std::endl;
  return nullptr;
}

static AllocaInst *CreateEntryBlockAlloca(Function *fun, StringRef VarName) {
  IRBuilder<> TmpB(&fun->getEntryBlock(), fun->getEntryBlock().begin());
  return TmpB.CreateAlloca(Type::getDoubleTy(*context), nullptr, VarName);
}

driver::driver(): trace_parsing(false), trace_scanning(false) {}

int driver::parse(const std::string &f) {
  // File path
  file = f;
  location.initialize(&file);

  // Start scanning
  scan_begin();
  yy::parser parser(*this);
  parser.set_debug_level(trace_parsing);
  int res = parser.parse();
  scan_end();
  return res;
}

void driver::codegen() {
  root->codegen(*this);
}

//************************* Sequence tree **************************
SeqAST::SeqAST(RootAST* first, RootAST* continuation): first(first), continuation(continuation) {}

Value *SeqAST::codegen(driver& drv) {
  if (first != nullptr) {
    Value *f = first->codegen(drv);
  } else {
    if (continuation == nullptr) return nullptr;
  }
  Value *c = continuation->codegen(drv);
  return nullptr;
}

//********************* Number Expression Tree *********************
NumberExprAST::NumberExprAST(double Val): Val(Val) {}

lexval NumberExprAST::getLexVal() const {
  lexval lval = Val;
  return lval;
}

Value *NumberExprAST::codegen(driver& drv) {  
  return ConstantFP::get(*context, APFloat(Val));
}

//******************** Variable Expression Tree ********************
VariableExprAST::VariableExprAST(const std::string &Name): Name(Name) {}

lexval VariableExprAST::getLexVal() const {
  lexval lval = Name;
  return lval;
}

Value *VariableExprAST::codegen(driver& drv) {
  AllocaInst *A = drv.NamedValues[Name];
  if (!A) {
    GlobalVariable* gVariable = module->getNamedGlobal(Name);
    if (gVariable != nullptr) {
      return builder->CreateLoad(gVariable->getValueType(), gVariable, Name);
    } else {
      return LogErrorV("Variabile " + Name + " non definita");
    }
  }
  return builder->CreateLoad(A->getAllocatedType(), A, Name.c_str());
}

//******************** Binary Expression Tree **********************
BinaryExprAST::BinaryExprAST(char Op, ExprAST* LHS, ExprAST* RHS): Op(Op), LHS(LHS), RHS(RHS) {}

Value *BinaryExprAST::codegen(driver& drv) {
  Value *L = LHS->codegen(drv);
  Value *R = RHS->codegen(drv);
  if (!L || !R) 
    return nullptr;
  switch (Op) {
    case '+':
      return builder->CreateFAdd(L, R, "addres");
    case '-':
      return builder->CreateFSub(L, R, "subres");
    case '*':
      return builder->CreateFMul(L, R, "mulres");
    case '/':
      return builder->CreateFDiv(L, R, "addres");
    case '<':
      return builder->CreateFCmpULT(L, R, "lttest");
    case '=':
      return builder->CreateFCmpUEQ(L, R, "eqtest");
    default:  
      std::cout << Op << std::endl;
      return LogErrorV("Operatore binario non supportato");
  }
}

//********************* Call Expression Tree ***********************
CallExprAST::CallExprAST(std::string Callee, std::vector<ExprAST*> Args): Callee(Callee), Args(std::move(Args)) {}

lexval CallExprAST::getLexVal() const {
  lexval lval = Callee;
  return lval;
}

Value* CallExprAST::codegen(driver& drv) {
  Function *CalleeF = module->getFunction(Callee);
  if (!CalleeF)
    return LogErrorV("Funzione non definita");

  if (CalleeF->arg_size() != Args.size())
    return LogErrorV("Numero di argomenti non corretto");

  std::vector<Value *> ArgsV;
  for (auto arg : Args) {
    ArgsV.push_back(arg->codegen(drv));
    if (!ArgsV.back())
      return nullptr;
  }
  return builder->CreateCall(CalleeF, ArgsV, "calltmp");
}

//************************* If Expression Tree *************************
IfExprAST::IfExprAST(ExprAST* Cond, ExprAST* TrueExp, ExprAST* FalseExp): Cond(Cond), TrueExp(TrueExp), FalseExp(FalseExp) {}
   
Value* IfExprAST::codegen(driver& drv) {
  Value* CondV = Cond->codegen(drv);
  if (!CondV)
    return nullptr;
  
  Function *function = builder->GetInsertBlock()->getParent();
  BasicBlock *TrueBB =  BasicBlock::Create(*context, "trueexp", function);

  BasicBlock *FalseBB = BasicBlock::Create(*context, "falseexp");
  BasicBlock *MergeBB = BasicBlock::Create(*context, "endcond");
  
  builder->CreateCondBr(CondV, TrueBB, FalseBB);
  
  builder->SetInsertPoint(TrueBB);
  Value *TrueV = TrueExp->codegen(drv);
  if (!TrueV)
    return nullptr;
  builder->CreateBr(MergeBB);
  
  TrueBB = builder->GetInsertBlock();
  function->insert(function->end(), FalseBB);
  
  builder->SetInsertPoint(FalseBB);
  
  Value *FalseV = FalseExp->codegen(drv);

  if (!FalseV)
    return nullptr;

  builder->CreateBr(MergeBB);
  
  FalseBB = builder->GetInsertBlock();
  function->insert(function->end(), MergeBB);
  
  builder->SetInsertPoint(MergeBB);

  PHINode *PN = builder->CreatePHI(Type::getDoubleTy(*context), 2, "condval");
  PN->addIncoming(TrueV, TrueBB);
  PN->addIncoming(FalseV, FalseBB);
  return PN;
}

//************************* Var binding Tree *************************
VarBindingAST::VarBindingAST(const std::string Name, ExprAST* Val): Name(Name), Val(Val) {}
   
const std::string& VarBindingAST::getName() const { 
  return Name; 
}

AllocaInst* VarBindingAST::codegen(driver& drv) {
  Function *fun = builder->GetInsertBlock()->getParent();
  Value *BoundVal;

  if (Val) {
    BoundVal = Val->codegen(drv);
    if (!BoundVal)
      return nullptr;
  }

  AllocaInst *Alloca = CreateEntryBlockAlloca(fun, Name);
  if (Val) {
    builder->CreateStore(BoundVal, Alloca);
  }

  return Alloca;
}

//************************* Prototype Tree *************************
PrototypeAST::PrototypeAST(std::string Name, std::vector<std::string> Args): Name(Name), Args(std::move(Args)), emitcode(true) {}

lexval PrototypeAST::getLexVal() const {
  lexval lval = Name;
  return lval;	
}

const std::vector<std::string>& PrototypeAST::getArgs() const { 
   return Args;
}

void PrototypeAST::noemit() { 
   emitcode = false; 
}

Function *PrototypeAST::codegen(driver &drv) {
  std::vector<Type*> Doubles(Args.size(), Type::getDoubleTy(*context));

  FunctionType *FT = FunctionType::get(Type::getDoubleTy(*context), Doubles, false);

  Function *F = Function::Create(FT, Function::ExternalLinkage, Name, *module);

  unsigned Idx = 0;
  for (auto &Arg : F->args())
    Arg.setName(Args[Idx++]);

  if (emitcode) {
    F->print(errs());
    fprintf(stderr, "\n");
  }
  
  return F;
}

//************************* Function Tree **************************
FunctionAST::FunctionAST(PrototypeAST *Proto, StatementAST *Body): Proto(Proto), Body(Body) {}

Function *FunctionAST::codegen(driver &drv) {
  Function *function = module->getFunction(std::get<std::string>(Proto->getLexVal()));
  if (!function)
    function = Proto->codegen(drv);
  else
    return nullptr;
  if (!function)
    return nullptr;  

  BasicBlock *BB = BasicBlock::Create(*context, "entry", function);
  builder->SetInsertPoint(BB);
 
  for (auto &Arg : function->args()) {
    AllocaInst *Alloca = CreateEntryBlockAlloca(function, Arg.getName());

    builder->CreateStore(&Arg, Alloca);
    drv.NamedValues[std::string(Arg.getName())] = Alloca;
  }

  if (Value *RetVal = Body->codegen(drv)) {
    builder->CreateRet(RetVal);

    verifyFunction(*function);
 
    function->print(errs());
    fprintf(stderr, "\n");
    return function;
  }

  function->eraseFromParent();
  return nullptr;
}

//************************* Global Tree *************************
GlobalVarAST::GlobalVarAST(const std::string Name): Name(Name) {} 


GlobalVariable *GlobalVarAST::codegen(driver &drv) {
  GlobalVariable *gVariable = new GlobalVariable(
    *module, 
    Type::getDoubleTy(*context), 
    false, 
    GlobalValue::CommonLinkage, 
    ConstantFP::get(Type::getDoubleTy(*context), 0.0), 
    Name
  );
  
  gVariable->print(errs());
  fprintf(stderr, "\n");

  return gVariable;
}

//*************************Assignment AST*************************************

AssignmentAST::AssignmentAST(const std::string Name, ExprAST *assignmentEXPR): Name(Name), assignmentEXPR(assignmentEXPR) {}

const std::string &AssignmentAST::getName() const { return Name; }

Value *AssignmentAST::codegen(driver &drv){
  Value *A = drv.NamedValues[Name];
  if (!A){
    A = module->getNamedGlobal(Name);
    if (!A){
      return LogErrorV("Variabile " + Name + " non definita");
    }
  }
  Value *RHS = assignmentEXPR->codegen(drv);

  if (!RHS){
    return nullptr;
  }

  builder->CreateStore(RHS, A);
  return RHS;
}

//********************Block AST*************************************************

BlockAST::BlockAST(std::vector<VarBindingAST*> definition, std::vector<StatementAST*> statements): definition(std::move(definition)), statements(std::move(statements)) {}

BlockAST::BlockAST(std::vector<StatementAST*> statements): statements(std::move(statements)) {}

Value *BlockAST::codegen(driver& drv){
  std::vector<AllocaInst*> AllocaTmp;
  for (int i=0, e=definition.size(); i<e && !definition.empty(); i++) {
    AllocaInst *boundval = definition[i]->codegen(drv);
    if (!boundval) 
      return nullptr;
    AllocaTmp.push_back(drv.NamedValues[definition[i]->getName()]);
    drv.NamedValues[definition[i]->getName()] = boundval;
  }
  Value *blockvalue;
  for (int i = 0; i < statements.size(); i++){
    blockvalue = statements[i]->codegen(drv);
    if (!blockvalue){
      return nullptr;
    }
  }
  for (int i=0, e=definition.size(); i<e && !definition.empty(); i++) {
    drv.NamedValues[definition[i]->getName()] = AllocaTmp[i];
  }

  return blockvalue;
}

//************************* IfStatementAST ***************************************
IfStatementAST::IfStatementAST(ExprAST *condition, StatementAST *thenBlock): condition(condition), thenBlock(thenBlock) {}

IfStatementAST::IfStatementAST(ExprAST *condition, StatementAST *thenBlock, StatementAST *elseBlock): condition(condition), thenBlock(thenBlock), elseBlock(elseBlock) {}

Value *IfStatementAST::codegen(driver &drv) {
  Function *fun = builder->GetInsertBlock()->getParent();

  BasicBlock *thenBB = BasicBlock::Create(*context, "then", fun);
  BasicBlock *elseBB = BasicBlock::Create(*context, "else", fun);
  BasicBlock *MergeBB = BasicBlock::Create(*context, "ifcont", fun);

  Value* conditionValue = condition->codegen(drv);
  if (!conditionValue) return nullptr;

  builder->CreateCondBr(conditionValue, thenBB, elseBB);


  builder->SetInsertPoint(thenBB);
  Value *thenValue = thenBlock->codegen(drv);
  if (!thenValue) return nullptr;
  builder->CreateBr(MergeBB);

  thenBB = builder->GetInsertBlock();

  
  fun->insert(fun->end(), elseBB);
  builder->SetInsertPoint(elseBB);

  if (elseBlock) {
    Value *elseValue = elseBlock->codegen(drv);
    if (!elseValue) return nullptr;
  }
  
  builder->CreateBr(MergeBB);


  elseBB = builder->GetInsertBlock();


  fun->insert(fun->end(), MergeBB);
  builder->SetInsertPoint(MergeBB);

  // Return dummy value
  return ConstantFP::get(*context, APFloat(0.0));
}


//************************* ForStatementAST ***************************************
ForStatementAST::ForStatementAST(InitAST* init, ExprAST* condition, AssignmentAST* increment, StatementAST* body): init(init), condition(condition), increment(increment), body(body) {}

Value* ForStatementAST::codegen(driver& drv) {
  Function *fun = builder->GetInsertBlock()->getParent();

  BasicBlock *InitBB = BasicBlock::Create(*context, "init",fun);
  BasicBlock *CondBB = BasicBlock::Create(*context, "cond",fun);
  BasicBlock *LoopBB = BasicBlock::Create(*context, "loop",fun);
  BasicBlock *EndLoop = BasicBlock::Create(*context, "loopend",fun);
  

  builder->CreateBr(InitBB);
  builder->SetInsertPoint(InitBB);

  VarBindingAST* test = dynamic_cast<VarBindingAST*>(init);
  
  std::string varName = init->getName();
  AllocaInst* oldVar;
  Value* initVal = init->codegen(drv);

  if (!initVal) return nullptr;
  
  if (test){
    oldVar = drv.NamedValues[varName];
    drv.NamedValues[varName] = (AllocaInst*) initVal;
  }

  builder->CreateBr(CondBB);
  fun->insert(fun->end(), CondBB);
  builder->SetInsertPoint(CondBB);


  Value *condVal = condition->codegen(drv);
  if(!condVal) return nullptr;


  builder->CreateCondBr(condVal, LoopBB, EndLoop);

  fun->insert(fun->end(), LoopBB);
  builder->SetInsertPoint(LoopBB);

  Value *bodyVal = body->codegen(drv);
  if(!bodyVal) return nullptr;

  Value* stepVal = increment->codegen(drv);
  if(!stepVal) return nullptr;

  builder->CreateBr(CondBB);

  fun->insert(fun->end(), EndLoop);
  builder->SetInsertPoint(EndLoop);

  if(test){
    drv.NamedValues[varName] = oldVar;
  }

  // Return dummy value
  return ConstantFP::get(*context, APFloat(0.0));
}
