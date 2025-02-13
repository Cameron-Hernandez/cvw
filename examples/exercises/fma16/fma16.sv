module fma16(input logic [15:0] x, y, z,
             input logic mul, add, negp, negz,
             input logic [1:0] roundmode, 
             output logic [15:0] result,
             output logic [3:0] flags);


    mult m1(x, y, negp, result);
    assign flags = 0;
endmodule 

module mult(input logic [15:0] x, y,
            input logic negp, 
            output logic [15:0] result);
    
    logic msbX, msbY, msb; 
    logic [4:0] expX, expY;
    logic [5:0] expSum, exp;
    logic [10:0] mantX, mantY, mantSum;
    logic [21:0] mant;

    always_comb begin
    // Multiplying Mantissa
        //create the implicit leading 1
        mantX = {1'b1, x[9:0]};
        mantY = {1'b1, y[9:0]};

        mant = mantX * mantY;

        //Normalize Result
        mantSum = (mant[21]) ? mant[21:11] : mant[20:10]; //will drop the implicit 1 at the end

    
    // Adding Exponents
        msbX = x[15];
        msbY = y[15];
        expX = x[14:10];
        expY = y[14:10];

        expSum = expX + expY -15;

        exp = (mant[21]) ? expSum + 1 : expSum;


    // Most Significant bit
        msbX = x[15];
        msbY = y[15];
        msb = negp ^ msbX ^ msbY; 

    //Append calculated values to result
        result = {msb, exp[4:0],mantSum[9:0]};
    end
endmodule 