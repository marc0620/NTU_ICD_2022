`timescale 1ns/1ps
module kendall_rank(kendall, i0_x, i0_y, i1_x, i1_y, i2_x, i2_y, i3_x, i3_y);
//DO NOT CHANGE!
    input  [3:0] i0_x, i0_y, i1_x, i1_y, i2_x, i2_y, i3_x, i3_y;
    output [3:0] kendall;
//---------------------------------------------------
    wire c0,c1,c2,c3,c4,c5;
    COMPARATOR C01(c0,i0_x,i0_y,i1_x,i1_y);
    COMPARATOR C02(c1,i0_x,i0_y,i2_x,i2_y);
    COMPARATOR C03(c2,i0_x,i0_y,i3_x,i3_y);
    COMPARATOR C12(c3,i1_x,i1_y,i2_x,i2_y);
    COMPARATOR C13(c4,i1_x,i1_y,i3_x,i3_y);
    COMPARATOR C23(c5,i2_x,i2_y,i3_x,i3_y);
    
    MUX4l6 m(kendall,{c5,c4,c3,c2,c1,c0});
endmodule



module COMPARATOR(out,ax,ay,bx,by);
    input [3:0] ax, ay, bx, by;
    output out;
    wire w0,w1,w2,w3,w4,w5,w6,w7;
    wire [3:0] datax,datay,datx,daty;
    wire [3:0] bx_inv,by_inv;
    
    EO xor0(w0,ax[3],bx[3]);
    EO xor1(w1,ax[2],bx[2]);
    EO xor2(w2,ax[1],bx[1]);
    EO xor4(w4,ay[3],by[3]);
    EO xor5(w5,ay[2],by[2]);
    EO xor6(w6,ay[1],by[1]);
    
    

    wire w0_inv,w1_inv,w2_inv,w4_inv,w5_inv,w6_inv;
    IV iv0(w0_inv,w0);
    IV iv1(w1_inv,w1);
    IV iv2(w2_inv,w2);
    IV iv4(w4_inv,w4);
    IV iv5(w5_inv,w5);
    IV iv6(w6_inv,w6);

    IV iv7(bx_inv[3],bx[3]);
    IV iv8(bx_inv[2],bx[2]);
    IV iv9(bx_inv[1],bx[1]);
    IV iv10(bx_inv[0],bx[0]);
    IV iv11(by_inv[3],by[3]);
    IV iv12(by_inv[2],by[2]);
    IV iv13(by_inv[1],by[1]);
    IV iv14(by_inv[0],by[0]);

    AN2 and0(datx[3],ax[3],bx_inv[3]);
    AN2 and1(datx[2],ax[2],bx_inv[2]);
    AN2 and2(datx[1],ax[1],bx_inv[1]);
    AN2 and3(datx[0],ax[0],bx_inv[0]);

    AN2 and4(daty[3],ay[3],by_inv[3]);
    AN2 and5(daty[2],ay[2],by_inv[2]);
    AN2 and6(daty[1],ay[1],by_inv[1]);
    AN2 and7(daty[0],ay[0],by_inv[0]);
    
    IV iv15(datax[3],datx[3]);
    IV iv16(datay[3],daty[3]);
    ND2 and8(datax[2],datx[2],w0_inv);
    ND3 and9(datax[1],datx[1],w0_inv,w1_inv);
    ND4 and10(datax[0],datx[0],w0_inv,w1_inv,w2_inv);

    ND2 and11(datay[2],daty[2],w4_inv);
    ND3 and12(datay[1],daty[1],w4_inv,w5_inv);
    ND4 and13(datay[0],daty[0],w4_inv,w5_inv,w6_inv);


    wire resultx,resulty;
    ND4 or0(resultx, datax[3],datax[2],datax[1],datax[0]);
    ND4 or1(resulty, datay[3],datay[2],datay[1],datay[0]);

    EO eo0(out,resultx,resulty);
    //assign out=resultx_inv^resulty_inv;

    
endmodule




module MUX4(out,in1,in2,ctrl);
    input [3:0] in1,in2;
    input ctrl;
    output [3:0] out;
    MUX21H m0(out[0],in1[0],in2[0],ctrl);
    MUX21H m1(out[1],in1[1],in2[1],ctrl);
    MUX21H m2(out[2],in1[2],in2[2],ctrl);
    MUX21H m3(out[3],in1[3],in2[3],ctrl);
endmodule

module MUX4l2(out,in1,in2,in3,in4,ctrl);
    input [3:0] in1,in2,in3,in4;
    input [1:0] ctrl;
    output[3:0] out;
    wire [3:0] w0,w1;
    MUX4 m0(w0,in1,in2,ctrl[1]);
    MUX4 m1(w1,in3,in4,ctrl[1]);
    MUX4 m2(out,w0,w1,ctrl[0]);
endmodule
module MUX4l4(out,in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,in11,in12,in13,in14,in15,in16,ctrl);
    input[3:0] in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,in11,in12,in13,in14,in15,in16;
    input [3:0] ctrl;
    output [3:0] out;
    wire[3:0] w0,w1,w2,w3;
    MUX4l2 m0(w0,in1,in2,in3,in4,ctrl[3:2]);
    MUX4l2 m1(w1,in5,in6,in7,in8,ctrl[3:2]);
    MUX4l2 m2(w2,in9,in10,in11,in12,ctrl[3:2]);
    MUX4l2 m3(w3,in13,in14,in15,in16,ctrl[3:2]);
    MUX4l2 m4(out,w0,w1,w2,w3,ctrl[1:0]);
endmodule
module MUX4l6(out,ctrl);
    input[5:0]ctrl;
    output[3:0]out;
    wire[3:0] w0,w1,w2;
    wire [3:0]case0,case1,case2,case3,case4,case5,case6;
    assign case0=4'b0100,case1=4'b0011,case2=4'b0001,case3=4'b0000,case4=4'b1111,case5=4'b1101,case6=4'b1100;
    MUX4l4 m0(w0,case0,case1,case1,case2,case1,case2,case2,case3,case1,case2,case2,case3,case2,case3,case3,case4,ctrl[5:2]);
    MUX4l4 m1(w1,case1,case2,case2,case3,case2,case3,case3,case4,case2,case3,case3,case4,case3,case4,case4,case5,ctrl[5:2]);
    MUX4l4 m2(w2,case2,case3,case3,case4,case3,case4,case4,case5,case3,case4,case4,case5,case4,case5,case5,case6,ctrl[5:2]);
    MUX4l2 m3(out,w0,w1,w1,w2,ctrl[1:0]);

endmodule


