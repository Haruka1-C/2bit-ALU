module adder(a, b, c, d, cout, a1, a0);
	input	a, b, c, d;
	output	cout, a1, a0;
	wire	cout_w1, cout_w2, cout_w3,
		a1_w1, a1_w2;

	//cout
	and	AA1(cout_w1, b, c, d); //AA1 => Adder AND 1
	and	AA2(cout_w2, a, b, d);
	and	AA3(cout_w3, a, c);
	or	AO1(cout, cout_w1, cout_w2, cout_w3);

	//a1
	and	AA4(a1_w1, b, d);
	xor	AXO1(a1_w2, a, c);
	xor	AXO2(a1, a1_w1, a1_w2);

	//a0
	xor	AXO3(a0, b, d);
endmodule


module subtractor(a, b, c, d, borrow, s1, s0);
	input 	a, b, c, d;
	output	borrow, s1, s0;
	wire	sna, snb, snc,
		borrow_w1, borrow_w2, borrow_w3,
		s1_w1, s1_w2;

	not 	SN1(sna, a);
	not	SN2(snb, b);
	not	SN3(snd, d);

	//borrow
	and	SA1(borrow_w1, sna, snb, d);
	and	SA2(borrow_w2, snb, c, d);
	and	SA3(borrow_w3, sna, c);
	or	SO1(borrow, borrow_w1, borrow_w2, borrow_w3);
	
	//s1
	or	SO2(s1_w1, b, snd);
	xor	SXO1(s1_w2, a, c);
	xnor	SXNO1(s1, s1_w1, s1_w2);

	//s0
	xor	SXO2(s0, b, d);
endmodule


module multiplier(a, b, c, d, m3, m2, m1, m0);
	input 	a, b, c, d;
	output	m3, m2, m1, m0; 
	wire	mac, mad, mbc, mbd, mnbd;

	and	MA1(mac, a, c);
	and	MA2(mad, a, d);
	and	MA3(mbc, b, c);
	and	MA4(mbd, b, d);

	//m3
	and	MA5(m3, mac, mbd);

	//m2
	not	MN1(mnbd, mbd);
	and	MA6(m2, mnbd, mac);

	//m1
	xor	MXO1(m1, mad, mbc);

	//m0
	assign	m0 = mbd;
endmodule


module mux4to1(out, i0, i1, i2, i3, sel);
    input wire i0, i1, i2, i3;
    input wire [1:0] sel;
    output wire out;

    assign out = (sel == 2'b00) ? i0 :
                 (sel == 2'b01) ? i1 :
                 (sel == 2'b10) ? i2 :
                 (sel == 2'b11) ? i3 : 1'b0;
endmodule


module Two_bit_ALU(x1, x0, y1, y0, out3, out2, out1, out0, sel1, sel0);
    input  	x1, x0, y1, y0, sel1, sel0;
    output 	out3, out2, out1, out0;
    wire   	wcout, wa1, wa0, wborrow, ws1, ws0, wm3, wm2, wm1, wm0;

    adder  	ADD(x1, x0, y1, y0, wcout, wa1, wa0);
    subtractor  SUB(x1, x0, y1, y0, wborrow, ws1, ws0);
    multiplier  MUL(x1, x0, y1, y0, wm3, wm2, wm1, wm0);

    wire [1:0] sel;
    assign sel = {sel1, sel0};

    mux4to1  MUX3(out3, 1'b0, 1'b0, 1'b0, wm3, sel);
    mux4to1  MUX2(out2, 1'b0, wcout, wborrow, wm2, sel);
    mux4to1  MUX1(out1, 1'b0, wa1, ws1, wm1, sel);
    mux4to1  MUX0(out0, 1'b0, wa0, ws0, wm0, sel);
endmodule
