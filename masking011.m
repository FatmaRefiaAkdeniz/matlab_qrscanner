function unmasked_qr = masking011(binary_qr)
[rows, cols] = size(binary_qr);
masked_qr = ones(rows, cols);

for i = 1:2:rows
    masked_qr(i,:) = 0;
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