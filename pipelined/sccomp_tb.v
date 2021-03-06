
// testbench for simulation
module sccomp_tb();

    reg  clk, rstn;
    reg  [4:0] reg_sel;
    wire [31:0] reg_data;

    // instantiation of sccomp    
    sccomp U_SCCOMP(
        .clk(clk), .rstn(rstn), .reg_sel(reg_sel), .reg_data(reg_data) 
    );

    integer foutput;
    integer counter = 0;

    initial begin
        $readmemh( "C:\\Users\\11630\\OneDrive - whu.edu.cn\\4-csapp2\\sc\\Test_37_Instr2.dat" , U_SCCOMP.U_IM.ROM); // load instructions into instruction memory
        $monitor("PC = 0x%8X, instr = 0x%8X", U_SCCOMP.PC, U_SCCOMP.instr); // used for debug
        foutput = $fopen("results.txt");
        clk = 1;
        rstn = 1;
        #5 ;
        rstn = 0;
        #20 ;
        rstn = 1;
        #1000 ;
        reg_sel = 7;
    end

    always begin
        #(50) clk = ~clk;
            
        if (clk == 1'b1) begin
            if ((counter == 300) || (U_SCCOMP.U_SCPU.PC === 32'hxxxxxxxx)) begin
                $fclose(foutput);
                $stop;
            end 
            else begin
            
                $fdisplay(foutput, "pc:\t %h", U_SCCOMP.PC);
                $fdisplay(foutput, "inst:\t %h", U_SCCOMP.instr);

                // $fdisplay(foutput, "rf[5]:\t %h ", U_SCCOMP.U_SCPU.U_RF.rf[5]);
                // $fdisplay(foutput, "rf[7]:\t %h ", U_SCCOMP.U_SCPU.U_RF.rf[7]);
                // $fdisplay(foutput, "rf[8]:\t %h ", U_SCCOMP.U_SCPU.U_RF.rf[8]);
                $fdisplay(foutput, "rf[23]:\t %h ", U_SCCOMP.U_SCPU.U_RF.rf[23]);
                $fdisplay(foutput, "rf[24]:\t %h ", U_SCCOMP.U_SCPU.U_RF.rf[24]);
                // $fdisplay(foutput, "rf[29]:\t %h ", U_SCCOMP.U_SCPU.U_RF.rf[29]);
                
                $fdisplay(foutput, "dm[4]:\t %h %h %h %h\n", U_SCCOMP.U_DM.dmem[7], U_SCCOMP.U_DM.dmem[6], U_SCCOMP.U_DM.dmem[5], U_SCCOMP.U_DM.dmem[4]);
                
                // $fdisplay(foutput, "rf00-03:\t %h %h %h %h", 0, U_SCCOMP.U_SCPU.U_RF.rf[1], U_SCCOMP.U_SCPU.U_RF.rf[2], U_SCCOMP.U_SCPU.U_RF.rf[3]);
                // $fdisplay(foutput, "rf04-07:\t %h %h %h %h", U_SCCOMP.U_SCPU.U_RF.rf[4], U_SCCOMP.U_SCPU.U_RF.rf[5], U_SCCOMP.U_SCPU.U_RF.rf[6], U_SCCOMP.U_SCPU.U_RF.rf[7]);
                // $fdisplay(foutput, "rf08-11:\t %h %h %h %h", U_SCCOMP.U_SCPU.U_RF.rf[8], U_SCCOMP.U_SCPU.U_RF.rf[9], U_SCCOMP.U_SCPU.U_RF.rf[10], U_SCCOMP.U_SCPU.U_RF.rf[11]);
                // $fdisplay(foutput, "rf12-15:\t %h %h %h %h", U_SCCOMP.U_SCPU.U_RF.rf[12], U_SCCOMP.U_SCPU.U_RF.rf[13], U_SCCOMP.U_SCPU.U_RF.rf[14], U_SCCOMP.U_SCPU.U_RF.rf[15]);
                // $fdisplay(foutput, "rf16-19:\t %h %h %h %h", U_SCCOMP.U_SCPU.U_RF.rf[16], U_SCCOMP.U_SCPU.U_RF.rf[17], U_SCCOMP.U_SCPU.U_RF.rf[18], U_SCCOMP.U_SCPU.U_RF.rf[19]);
                // $fdisplay(foutput, "rf20-23:\t %h %h %h %h", U_SCCOMP.U_SCPU.U_RF.rf[20], U_SCCOMP.U_SCPU.U_RF.rf[21], U_SCCOMP.U_SCPU.U_RF.rf[22], U_SCCOMP.U_SCPU.U_RF.rf[23]);
                // $fdisplay(foutput, "rf24-27:\t %h %h %h %h", U_SCCOMP.U_SCPU.U_RF.rf[24], U_SCCOMP.U_SCPU.U_RF.rf[25], U_SCCOMP.U_SCPU.U_RF.rf[26], U_SCCOMP.U_SCPU.U_RF.rf[27]);
                // $fdisplay(foutput, "rf28-31:\t %h %h %h %h", U_SCCOMP.U_SCPU.U_RF.rf[28], U_SCCOMP.U_SCPU.U_RF.rf[29], U_SCCOMP.U_SCPU.U_RF.rf[30], U_SCCOMP.U_SCPU.U_RF.rf[31]);
                //$fdisplay(foutput, "hi lo:\t %h %h", U_SCCOMP.U_SCPU.U_RF.rf.hi, U_SCCOMP.U_SCPU.U_RF.rf.lo);
                  
                if (U_SCCOMP.PC == 32'h00000130) begin
                    counter = counter + 1;
                    // $fclose(foutput);
                    // $stop;
                end
                else begin
                    counter = counter + 1;
                end
            end
        end
    end //end always

endmodule
