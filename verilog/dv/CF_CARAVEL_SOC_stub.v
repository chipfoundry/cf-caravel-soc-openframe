// SPDX-FileCopyrightText: 2026 ChipFoundry
// SPDX-License-Identifier: Apache-2.0
// Simulation stub: SoC pad config idle, gpio_out held 0. Not for OpenLane.

`default_nettype none
`include "defines.v"

module CF_CARAVEL_SOC (
    inout vccd,
    inout vssd,
    input        porb_l,
    input        resetb_l,
    input [31:0] mask_rev,
    input  [`OPENFRAME_IO_PADS-1:0] gpio_in,
    output [`OPENFRAME_IO_PADS-1:0] gpio_out,
    output [`OPENFRAME_IO_PADS-1:0] gpio_oeb,
    output [`OPENFRAME_IO_PADS-1:0] gpio_inp_dis,
    output [`OPENFRAME_IO_PADS-1:0] gpio_ib_mode_sel,
    output [`OPENFRAME_IO_PADS-1:0] gpio_vtrip_sel,
    output [`OPENFRAME_IO_PADS-1:0] gpio_slow_sel,
    output [`OPENFRAME_IO_PADS-1:0] gpio_holdover,
    output [`OPENFRAME_IO_PADS-1:0] gpio_analog_en,
    output [`OPENFRAME_IO_PADS-1:0] gpio_analog_sel,
    output [`OPENFRAME_IO_PADS-1:0] gpio_analog_pol,
    output [`OPENFRAME_IO_PADS-1:0] gpio_dm2,
    output [`OPENFRAME_IO_PADS-1:0] gpio_dm1,
    output [`OPENFRAME_IO_PADS-1:0] gpio_dm0
);
    wire unused = porb_l & resetb_l & |mask_rev & |gpio_in;
    assign gpio_out = {`OPENFRAME_IO_PADS{1'b0}};
    assign gpio_oeb = {`OPENFRAME_IO_PADS{1'b1}};
    assign gpio_inp_dis = {`OPENFRAME_IO_PADS{1'b0}};
    assign gpio_ib_mode_sel = {`OPENFRAME_IO_PADS{1'b0}};
    assign gpio_vtrip_sel = {`OPENFRAME_IO_PADS{1'b0}};
    assign gpio_slow_sel = {`OPENFRAME_IO_PADS{1'b0}};
    assign gpio_holdover = {`OPENFRAME_IO_PADS{1'b0}};
    assign gpio_analog_en = {`OPENFRAME_IO_PADS{1'b0}};
    assign gpio_analog_sel = {`OPENFRAME_IO_PADS{1'b0}};
    assign gpio_analog_pol = {`OPENFRAME_IO_PADS{1'b0}};
    assign gpio_dm2 = {`OPENFRAME_IO_PADS{1'b0}};
    assign gpio_dm1 = {`OPENFRAME_IO_PADS{1'b0}};
    assign gpio_dm0 = {`OPENFRAME_IO_PADS{1'b0}};
endmodule
`default_nettype wire
