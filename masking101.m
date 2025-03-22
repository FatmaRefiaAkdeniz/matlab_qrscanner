function unmasked_qr = masking101(binary_qr)
[rows, cols] = size(binary_qr);
masked_qr = ones(rows, cols);

masked_qr=ones(rows,cols);
for i = 1:6:rows
    j = 1:2:cols;
    masked_qr(i,j) = 0;
end
for i = 4:6:rows
    j = 2:2:cols;
    masked_qr(i,j) = 0;
end

for i=2:6:rows
    for j=4:6:cols
        masked_qr(i, j:j+2) = 0;
        masked_qr(i+1, j+1:j+3) = 0;
    end
end

for i=5:6:rows
    for j=1:6:cols
        masked_qr(i, j:j+2) = 0;
        masked_qr(i+1, j+1:j+3) = 0;
         masked_qr = imcrop(masked_qr, [0, 0, rows,cols]);    
    end
end

masked_qr(1:9, 1:9) = binary_qr(1:9, 1:9);
masked_qr(rows-7:rows, 1:9) = binary_qr(rows-7:rows, 1:9);
masked_qr(1:9, cols-8:cols) = binary_qr(1:9, cols-8:cols);
masked_qr(7,9:13) = binary_qr(7,9:13);

masked_qr = im2bw(masked_qr);
unmasked_qr = xor(masked_qr, binary_qr);
unmasked_qr = imcomplement(unmasked_qr);
end
