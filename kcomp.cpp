#include <iostream>
#include "driver.hpp"

extern LLVMContext *context;
extern Module *module;
extern IRBuilder<> *builder;

int main (int argc, char *argv[]) {
  int res = 0;
  driver drv;
  int i = 1;

  while (i<argc) {
    if (argv[i] == std::string ("-p")) {
      drv.trace_parsing = true;
    } else if (argv[i] == std::string ("-s")) {
      drv.trace_scanning = true;
    } else if (!drv.parse(argv[i])) {
      drv.codegen();
    } else {
      res = 1;
    }
    i++;
  }
  return res;
}
