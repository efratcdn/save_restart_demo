/*
** my_dut.v
**  dummy, just defining signals
*/

module dut_demo;
   reg dut_clock;
   reg [7:0] test_r;
   reg [7:0] test_rw;
   
      
initial    
   begin
      dut_clock <= 1'b1;
      test_r = 1;
      test_rw = 1;      
   end // initial begin

    always
      #5 dut_clock = ~dut_clock;

endmodule // dut_evc_demo
