`default_nettype none
/// sta-blackbox
module CF_CARAVEL_SOC (
    inout vccd,
    inout vssd,
    input        porb_l,
    input        resetb_l,
    input [31:0] mask_rev,
    input  [43:0] gpio_in,
    output [43:0] gpio_out,
    output [43:0] gpio_oeb,
    output [43:0] gpio_inp_dis,
    output [43:0] gpio_ib_mode_sel,
    output [43:0] gpio_vtrip_sel,
    output [43:0] gpio_slow_sel,
    output [43:0] gpio_holdover,
    output [43:0] gpio_analog_en,
    output [43:0] gpio_analog_sel,
    output [43:0] gpio_analog_pol,
    output [43:0] gpio_dm2,
    output [43:0] gpio_dm1,
    output [43:0] gpio_dm0
);
endmodule
`default_nettype wire
