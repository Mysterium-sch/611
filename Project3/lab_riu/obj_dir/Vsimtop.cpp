// Verilated -*- SystemC -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vsimtop.h for the primary calling header

#include "Vsimtop.h"
#include "Vsimtop__Syms.h"

//==========

VL_SC_CTOR_IMP(Vsimtop) {
    Vsimtop__Syms* __restrict vlSymsp = __VlSymsp = new Vsimtop__Syms(this, name());
    Vsimtop* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Sensitivities on all clocks and combo inputs
    SC_METHOD(eval);
    
    // Reset internal values
    
    // Reset structure values
    _ctor_var_reset();
}

void Vsimtop::__Vconfigure(Vsimtop__Syms* vlSymsp, bool first) {
    if (0 && first) {}  // Prevent unused
    this->__VlSymsp = vlSymsp;
}

Vsimtop::~Vsimtop() {
    delete __VlSymsp; __VlSymsp=NULL;
}

void Vsimtop::eval() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vsimtop::eval\n"); );
    Vsimtop__Syms* __restrict vlSymsp = this->__VlSymsp;  // Setup global symbol table
    Vsimtop* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
#ifdef VL_DEBUG
    // Debug assertions
    _eval_debug_assertions();
#endif  // VL_DEBUG
    // Initialize
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) _eval_initial_loop(vlSymsp);
    // Evaluate till stable
    int __VclockLoop = 0;
    QData __Vchange = 1;
    do {
        VL_DEBUG_IF(VL_DBG_MSGF("+ Clock loop\n"););
        _eval(vlSymsp);
        if (VL_UNLIKELY(++__VclockLoop > 100)) {
            // About to fail, so enable debug to see what's not settling.
            // Note you must run make with OPT=-DVL_DEBUG for debug prints.
            int __Vsaved_debug = Verilated::debug();
            Verilated::debug(1);
            __Vchange = _change_request(vlSymsp);
            Verilated::debug(__Vsaved_debug);
            VL_FATAL_MT("simtop.sv", 2, "",
                "Verilated model didn't converge\n"
                "- See DIDNOTCONVERGE in the Verilator manual");
        } else {
            __Vchange = _change_request(vlSymsp);
        }
    } while (VL_UNLIKELY(__Vchange));
}

void Vsimtop::_eval_initial_loop(Vsimtop__Syms* __restrict vlSymsp) {
    vlSymsp->__Vm_didInit = true;
    _eval_initial(vlSymsp);
    // Evaluate till stable
    int __VclockLoop = 0;
    QData __Vchange = 1;
    do {
        _eval_settle(vlSymsp);
        _eval(vlSymsp);
        if (VL_UNLIKELY(++__VclockLoop > 100)) {
            // About to fail, so enable debug to see what's not settling.
            // Note you must run make with OPT=-DVL_DEBUG for debug prints.
            int __Vsaved_debug = Verilated::debug();
            Verilated::debug(1);
            __Vchange = _change_request(vlSymsp);
            Verilated::debug(__Vsaved_debug);
            VL_FATAL_MT("simtop.sv", 2, "",
                "Verilated model didn't DC converge\n"
                "- See DIDNOTCONVERGE in the Verilator manual");
        } else {
            __Vchange = _change_request(vlSymsp);
        }
    } while (VL_UNLIKELY(__Vchange));
}

void Vsimtop::_settle__TOP__1(Vsimtop__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsimtop::_settle__TOP__1\n"); );
    Vsimtop* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->simtop__DOT__imm12 = (0xfffU & (vlTOPp->simtop__DOT__instr 
                                            >> 0x14U));
    vlTOPp->simtop__DOT__rd = (0x1fU & (vlTOPp->simtop__DOT__instr 
                                        >> 7U));
    vlTOPp->simtop__DOT__op = (0x7fU & vlTOPp->simtop__DOT__instr);
}

void Vsimtop::_initial__TOP__2(Vsimtop__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsimtop::_initial__TOP__2\n"); );
    Vsimtop* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    if (VL_UNLIKELY((0x33U == (IData)(vlTOPp->simtop__DOT__op)))) {
        VL_WRITEF("work 1\n");
    }
    if (VL_UNLIKELY((5U == (IData)(vlTOPp->simtop__DOT__rd)))) {
        VL_WRITEF("work 2\n");
    }
    vlTOPp->simtop__DOT__instr = 0x3fff93U;
    if (VL_UNLIKELY((0x13U == (IData)(vlTOPp->simtop__DOT__op)))) {
        VL_WRITEF("work 3\n");
    }
    if (VL_UNLIKELY((3U == (IData)(vlTOPp->simtop__DOT__imm12)))) {
        VL_WRITEF("%x\n",12,vlTOPp->simtop__DOT__imm12);
    }
}

void Vsimtop::_eval(Vsimtop__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsimtop::_eval\n"); );
    Vsimtop* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
}

void Vsimtop::_eval_initial(Vsimtop__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsimtop::_eval_initial\n"); );
    Vsimtop* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_initial__TOP__2(vlSymsp);
}

void Vsimtop::final() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsimtop::final\n"); );
    // Variables
    Vsimtop__Syms* __restrict vlSymsp = this->__VlSymsp;
    Vsimtop* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
}

void Vsimtop::_eval_settle(Vsimtop__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsimtop::_eval_settle\n"); );
    Vsimtop* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    vlTOPp->_settle__TOP__1(vlSymsp);
}

VL_INLINE_OPT QData Vsimtop::_change_request(Vsimtop__Syms* __restrict vlSymsp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsimtop::_change_request\n"); );
    Vsimtop* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    // Body
    // Change detection
    QData __req = false;  // Logically a bool
    return __req;
}

#ifdef VL_DEBUG
void Vsimtop::_eval_debug_assertions() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsimtop::_eval_debug_assertions\n"); );
}
#endif  // VL_DEBUG

void Vsimtop::_ctor_var_reset() {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vsimtop::_ctor_var_reset\n"); );
    // Body
    simtop__DOT__instr = VL_RAND_RESET_I(32);
    simtop__DOT__op = VL_RAND_RESET_I(7);
    simtop__DOT__rd = VL_RAND_RESET_I(5);
    simtop__DOT__imm12 = VL_RAND_RESET_I(12);
}
