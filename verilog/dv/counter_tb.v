// SPDX-FileCopyrightText: 2026 ChipFoundry
// SPDX-License-Identifier: Apache-2.0

`timescale 1ns/1ps
`default_nettype none
`define USE_POWER_PINS
`include "defines.v"

module counter_tb;
    reg porb_l;
    reg resetb_l;
    reg [`OPENFRAME_IO_PADS-1:0] gpio_in;
    wire [`OPENFRAME_IO_PADS-1:0] gpio_out;
    wire [`OPENFRAME_IO_PADS-1:0] gpio_oeb;

    wire vdda, vdda1, vdda2, vssa, vssa1, vssa2;
    wire vccd, vccd1, vccd2, vssd, vssd1, vssd2, vddio, vssio;
    wire [`OPENFRAME_IO_PADS-1:0] analog_io, analog_noesd_io;
    wire [`OPENFRAME_IO_PADS-1:0] gpio_inp_dis, gpio_ib_mode_sel, gpio_vtrip_sel;
    wire [`OPENFRAME_IO_PADS-1:0] gpio_slow_sel, gpio_holdover;
    wire [`OPENFRAME_IO_PADS-1:0] gpio_analog_en, gpio_analog_sel, gpio_analog_pol;
    wire [`OPENFRAME_IO_PADS-1:0] gpio_dm2, gpio_dm1, gpio_dm0;

    integer i;

    openframe_project_wrapper uut (
        .vdda(vdda),
        .vdda1(vdda1),
        .vdda2(vdda2),
        .vssa(vssa),
        .vssa1(vssa1),
        .vssa2(vssa2),
        .vccd(vccd),
        .vccd1(vccd1),
        .vccd2(vccd2),
        .vssd(vssd),
        .vssd1(vssd1),
        .vssd2(vssd2),
        .vddio(vddio),
        .vssio(vssio),
        .porb_h(1'b1),
        .porb_l(porb_l),
        .por_l(~porb_l),
        .resetb_h(resetb_l),
        .resetb_l(resetb_l),
        .mask_rev(32'h0),
        .gpio_in(gpio_in),
        .gpio_in_h(gpio_in),
        .gpio_out(gpio_out),
        .gpio_oeb(gpio_oeb),
        .gpio_inp_dis(gpio_inp_dis),
        .gpio_ib_mode_sel(gpio_ib_mode_sel),
        .gpio_vtrip_sel(gpio_vtrip_sel),
        .gpio_slow_sel(gpio_slow_sel),
        .gpio_holdover(gpio_holdover),
        .gpio_analog_en(gpio_analog_en),
        .gpio_analog_sel(gpio_analog_sel),
        .gpio_analog_pol(gpio_analog_pol),
        .gpio_dm2(gpio_dm2),
        .gpio_dm1(gpio_dm1),
        .gpio_dm0(gpio_dm0),
        .analog_io(analog_io),
        .analog_noesd_io(analog_noesd_io),
        .gpio_loopback_one({`OPENFRAME_IO_PADS{1'b1}}),
        .gpio_loopback_zero({`OPENFRAME_IO_PADS{1'b0}})
    );

    initial begin
        gpio_in = {`OPENFRAME_IO_PADS{1'b0}};
        porb_l = 1'b0;
        resetb_l = 1'b0;
        gpio_in[38] = 1'b0;
        #20;
        gpio_in[38] = 1'b1;
        #12.5;
        gpio_in[38] = 1'b0;
        #12.5;
        porb_l = 1'b1;
        resetb_l = 1'b1;
        #40;
        if (gpio_out[23:8] !== 16'h0000) begin
            $display("FAIL: count not 0 after reset, got %h", gpio_out[23:8]);
            $finish;
        end
        for (i = 1; i <= 8; i = i + 1) begin
            gpio_in[38] = 1'b1;
            #12.5;
            gpio_in[38] = 1'b0;
            #12.5;
            if (gpio_out[23:8] !== i[15:0]) begin
                $display("FAIL: expected count %0d, got %0d", i, gpio_out[23:8]);
                $finish;
            end
        end
        $display("PASS: counter on gpio[23:8] incremented 1..8 from gpio[38]");
        $finish;
    end
endmodule
`default_nettype wire
