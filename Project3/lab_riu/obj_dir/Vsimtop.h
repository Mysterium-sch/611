// Verilated -*- SystemC -*-
// DESCRIPTION: Verilator output: Primary design header
//
// This header should be included by all source files instantiating the design.
// The class here is then constructed to instantiate the design.
// See the Verilator manual for examples.

#ifndef _VSIMTOP_H_
#define _VSIMTOP_H_  // guard

#include "systemc.h"
#include "verilated_sc.h"
#include "verilated_heavy.h"

//==========

class Vsimtop__Syms;

//----------

SC_MODULE(Vsimtop) {
  public:
    
    // LOCAL SIGNALS
    // Internals; generally not touched by application code
    CData/*6:0*/ simtop__DOT__op;
    CData/*4:0*/ simtop__DOT__rd;
    SData/*11:0*/ simtop__DOT__imm12;
    IData/*31:0*/ simtop__DOT__instr;
    
    // INTERNAL VARIABLES
    // Internals; generally not touched by application code
    Vsimtop__Syms* __VlSymsp;  // Symbol table
    
    // CONSTRUCTORS
  private:
    VL_UNCOPYABLE(Vsimtop);  ///< Copying not allowed
  public:
    SC_CTOR(Vsimtop);
    virtual ~Vsimtop();
    
    // API METHODS
  private:
    void eval();
  public:
    void final();
    
    // INTERNAL METHODS
  private:
    static void _eval_initial_loop(Vsimtop__Syms* __restrict vlSymsp);
  public:
    void __Vconfigure(Vsimtop__Syms* symsp, bool first);
  private:
    static QData _change_request(Vsimtop__Syms* __restrict vlSymsp);
    void _ctor_var_reset() VL_ATTR_COLD;
  public:
    static void _eval(Vsimtop__Syms* __restrict vlSymsp);
  private:
#ifdef VL_DEBUG
    void _eval_debug_assertions();
#endif  // VL_DEBUG
  public:
    static void _eval_initial(Vsimtop__Syms* __restrict vlSymsp) VL_ATTR_COLD;
    static void _eval_settle(Vsimtop__Syms* __restrict vlSymsp) VL_ATTR_COLD;
    static void _initial__TOP__2(Vsimtop__Syms* __restrict vlSymsp) VL_ATTR_COLD;
    static void _settle__TOP__1(Vsimtop__Syms* __restrict vlSymsp) VL_ATTR_COLD;
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);

//----------


#endif  // guard
