function unmasked_qr = masking110(binary_qr)
[rows, cols] = size(binary_qr);
masked_qr = zeros(rows, cols);

for n=1:4:rows
for k=4:6:cols
    masked_qr(n:n+1, k:k+2) = 1;
    masked_qr(21, k:k+2) =1;
end
end

for m=3:4:rows
    for l=1:6:cols
        masked_qr(m:m+1, l:l+2) = 1;
    end
end
masked_qr = imcrop(masked_qr, [0, 0, rows,cols]);  
masked_qr(1:9, 1:9) = binary_qr(1:9, 1:9);
masked_qr(rows-7:rows, 1:9) = binary_qr(rows-7:rows, 1:9);
masked_qr(1:9, cols-8:cols) = binary_qr(1:9, cols-8:cols);
masked_qr(7,9:13) = binary_qr(7,9:13);

masked_qr = im2bw(masked_qr);

unmasked_qr = xor(masked_qr, binary_qr);
unmasked_qr = imcomplement(unmasked_qr);
end