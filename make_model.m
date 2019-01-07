function make_model(path,sel,nn_size)

    inputs  = nn_size(1);
    outputs = 1;
    layers  = nn_size(2);
    layer_s = nn_size(3);
     
    for i = 1:layers+1
       cat_path_w = strcat(path,'\dump_w_',num2str(i-1),'.txt'); 
       cat_path_t = strcat(path,'\dump_t_',num2str(i-1),'.txt');
       fileID = fopen(cat_path_w,'r');
       formatSpec = '%d';
       cols = layer_s;
       rows = layer_s;
       if i == 1
           cols = inputs;
       elseif i == layers+1
           rows = outputs;
       end
       w(i).mat = fscanf(fileID,formatSpec,[cols rows])';
       fclose(fileID);
       fileID = fopen(cat_path_t,'r');
       formatSpec = '%d';
       t(i).mat = fscanf(fileID,formatSpec,[rows 1])';
       fclose(fileID);   
    end
    
    if sel == 0
        for i = 1:layers+1
            % Make standard model verilog code
            N = layer_s;
            M = layer_s;
            if i == 1
                N = inputs;
            elseif i == layers+1
                M = outputs;
            end
            lay = i;
            bits = ceil(log2(N+1)); 
            cat_path = strcat(path,'\standard_model_',num2str(i-1),'.txt'); 
            fid = fopen(cat_path,'w');

            % Generate
            fprintf(fid,'`timescale 1ns / 1ps');
            fprintf(fid,'\n\n');
            fprintf(fid,strcat('module layer_',num2str(i-1),'(in, out'));
            fprintf(fid,');\n\n');

            fprintf(fid,'  input [%d:0] in;\n',N-1);
            fprintf(fid,'  output reg [%d:0] out;\n',M-1);
            for i = 0:M-1
               %fprintf(fid,'  output reg out%d;\n',i);
               fprintf(fid,'  reg [%d:0] t%d;\n',bits-1,i);
               fprintf(fid,strcat('  reg [%d:0] w%d = %d''b'),N-1,i,N);
               for j = 1:N
                  fprintf(fid,'%d',w(lay).mat(i+1,j)); 
               end
               fprintf(fid,';\n');
               fprintf(fid,'  reg [%d:0] th%d = %d''d%d;\n',bits-1,i,bits,abs(t(lay).mat(i+1)));
               fprintf(fid,'  reg [%d:0] weighted%d;\n',N-1,i);
            end

            fprintf(fid,'\n\n');
            fprintf(fid,'  integer idx;\n\n');
            fprintf(fid, '  always @* begin\n');
            fprintf(fid, '    for( idx = 0; idx<%d; idx = idx + 1) begin\n',N);
            for i = 0:M-1
               fprintf(fid,'      weighted%d[idx] = ((w%d[idx])~^(in[idx]));\n',i,i); 
            end
            fprintf(fid,'    end\n');
            fprintf(fid,'  end\n');

            fprintf(fid,'\n\n');
            fprintf(fid, '  always @* begin\n');
            for i = 0:M-1
               fprintf(fid,'    t%d = ',i); 
               for j = 0:N-2
                  fprintf(fid, 'weighted%d[%d] + ',i,j); 
               end
               j = j + 1;
               fprintf(fid, 'weighted%d[%d];\n',i,j);
            end
            fprintf(fid,'  end \n');

            fprintf(fid,'\n\n');
            fprintf(fid, '  always @* begin\n');
            for i = 0:M-1
               fprintf(fid,'    out[%d] = t%d > th%d;\n',i,i,i); 
            end    
            fprintf(fid,'  end \n');

            fprintf(fid,'endmodule');
            fclose(fid);  
        end
    end
      
end
