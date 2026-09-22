// SPDX-FileCopyrightText: 2026 ChipFoundry
// SPDX-FileCopyrightText: 2020 Efabless Corporation
// SPDX-License-Identifier: Apache-2.0
//
// Hardenable shell around the counter from Caravel's user_proj_example.

`default_nettype none

// resetb is active low and count_oeb is driven here so that
// openframe_project_wrapper stays structural for elaborate-only integration.
module counter_macro (
    inout VPWR,
    inout VGND,
    input clk,
    input resetb,
    output [15:0] count,
    output [15:0] count_oeb
);
    wire ready_unused;
    wire [15:0] rdata_unused;
    wire reset = ~resetb;

    assign count_oeb = 16'b0;

    counter #(
        .BITS(16)
    ) u_counter (
        .clk(clk),
        .reset(reset),
        .valid(1'b0),
        .wstrb(4'b0),
        .wdata(16'b0),
        .la_write(16'b0),
        .la_input(16'b0),
        .ready(ready_unused),
        .rdata(rdata_unused),
        .count(count)
    );
endmodule

`default_nettype wire
