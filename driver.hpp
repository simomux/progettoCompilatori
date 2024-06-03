#ifndef DRIVER_HPP
#define DRIVER_HPP

//************************* IR related modules ******************************
#include "llvm/ADT/APFloat.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/Verifier.h"

//**************** C++ modules and generic data types ***********************
#include <cstdio>
#include <cstdlib>
#include <map>
#include <string>
#include <vector>
#include <variant>

#include "parser.hpp"

using namespace llvm;


# define YY_DECL \
  yy::parser::symbol_type yylex (driver& drv) 
  YY_DECL;

class driver {
public:
  driver();
  std::map<std::string, AllocaInst*> NamedValues;
  RootAST* root;
  int parse (const std::string& f);
  std::string file;
  bool trace_parsing;
  void scan_begin ();
  void scan_end ();
  bool trace_scanning;
  yy::location location;
  void codegen();
};

typedef std::variant<std::string,double> lexval;
const lexval NONE = 0.0;


class RootAST {
public:
  virtual ~RootAST() {};
  virtual lexval getLexVal() const {return NONE;};
  virtual Value *codegen(driver& drv) { return nullptr; };
};

class StatementAST : public RootAST {};


class SeqAST : public RootAST {
private:
  RootAST* first;
  RootAST* continuation;

public:
  SeqAST(RootAST* first, RootAST* continuation);
  Value *codegen(driver& drv) override;
};


class ExprAST : public StatementAST {};


class NumberExprAST : public ExprAST {
private:
  double Val;

public:
  NumberExprAST(double Val);
  lexval getLexVal() const override;
  Value *codegen(driver& drv) override;
};


class VariableExprAST : public ExprAST {
private:
  std::string Name;
  
public:
  VariableExprAST(const std::string &Name);
  lexval getLexVal() const override;
  Value *codegen(driver& drv) override;
};


class BinaryExprAST : public ExprAST {
private:
  char Op;
  ExprAST* LHS;
  ExprAST* RHS;

public:
  BinaryExprAST(ExprAST* LHS, char Op, ExprAST* RHS);
  Value *codegen(driver& drv) override;
};


class CallExprAST : public ExprAST {
private:
  std::string Callee;
  std::vector<ExprAST*> Args;

public:
  CallExprAST(std::string Callee, std::vector<ExprAST*> Args);
  lexval getLexVal() const override;
  Value *codegen(driver& drv) override;
};


class IfExprAST : public ExprAST {
private:
  ExprAST* Cond;
  ExprAST* TrueExp;
  ExprAST* FalseExp;
public:
  IfExprAST(ExprAST* Cond, ExprAST* TrueExp, ExprAST* FalseExp);
  Value *codegen(driver& drv) override;
};


class InitAST : public StatementAST {
  private:
    std::string Name;
  public:
    virtual const std::string& getName() const {return Name;};
};


class VarBindingAST: public InitAST {
private:
  const std::string Name;
  ExprAST* Val;
public:
  VarBindingAST(const std::string Name, ExprAST* Val);
  AllocaInst *codegen(driver& drv) override;
  const std::string& getName() const override;
};


class PrototypeAST : public RootAST {
private:
  std::string Name;
  std::vector<std::string> Args;
  bool emitcode;

public:
  PrototypeAST(std::string Name, std::vector<std::string> Args);
  const std::vector<std::string> &getArgs() const;
  lexval getLexVal() const override;
  Function *codegen(driver& drv) override;
  void noemit();
};


class FunctionAST : public RootAST {
private:
  PrototypeAST* Proto;
  StatementAST* Body;
  bool external;
  
public:
  FunctionAST(PrototypeAST* Proto, StatementAST* Body);
  Function *codegen(driver& drv) override;
};


// 1st level grammar
class GlobalVarAST : public RootAST {
private:
  const std::string Name;
  
public:
  GlobalVarAST(const std::string Name);
  GlobalVariable *codegen(driver& drv) override;
};


class BlockAST : public StatementAST {
  private:
    std::vector<VarBindingAST*> definition;
    std::vector<StatementAST*> statements;
  public:
    BlockAST(std::vector<VarBindingAST*> definition, std::vector<StatementAST*> statements);
    BlockAST(std::vector<StatementAST*> statements);
    Value *codegen(driver& drv) override;
};

class AssignmentAST : public InitAST {
  private:
    const std::string Name;
    ExprAST* assignmentEXPR;
  public:
    AssignmentAST(const std::string Name, ExprAST* assignmentEXPR);
    const std::string& getName() const override;
    Value *codegen(driver& drv) override;
};


// 2nd level grammar
class IfStatementAST : public StatementAST {
  private:
    ExprAST* condition;
    StatementAST* thenBlock;
    StatementAST* elseBlock;
  public:
    IfStatementAST(ExprAST* condition, StatementAST* thenBlock);
    IfStatementAST(ExprAST* condition, StatementAST* thenBlock, StatementAST* elseBlock);
    Value *codegen(driver& drv) override;
    
};


class ForStatementAST : public StatementAST {
  private:
    InitAST* init;
    ExprAST* condition;
    AssignmentAST* increment;
    StatementAST* body;
  public:
    ForStatementAST(InitAST* init, ExprAST* condition, AssignmentAST* increment, StatementAST* body);
    Value *codegen(driver& drv) override;
};

#endif
