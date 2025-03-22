function unmasked_qr = masking010(binary_qr)

[rows, cols] = size(binary_qr);

masked_qr = zeros(rows, cols);

masked_qr(1:2:rows, 2:2:cols) = 1;
masked_qr(2:2:rows, 1:2:cols) = 1;
masked_qr = imcrop(masked_qr, [0, 0, rows,cols]);  

masked_qr(1:9, 1:9) = binary_qr(1:9, 1:9);
masked_qr(rows-7:rows, 1:9) = binary_qr(rows-7:rows, 1:9);
masked_qr(1:9, cols-8:cols) = binary_qr(1:9, cols-8:cols);
masked_qr(7,9:13) = binary_qr(7,9:13);

masked_qr = im2bw(masked_qr);
unmasked_qr = xor(masked_qr, binary_qr);
unmasked_qr = imcomplement(unmasked_qr);

end