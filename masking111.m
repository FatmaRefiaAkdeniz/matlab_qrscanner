function unmasked_qr = masking111(binary_qr)
[rows, cols] = size(binary_qr);
masked_qr = ones(rows, cols);

for i = 1:6:rows
    for j = 1:6:cols
        masked_qr(i, :) = 0;
        masked_qr(:, j) = 0;
        masked_qr(i+2, j+3) = 0;
        masked_qr(i+3,j+2) = 0;
        masked_qr(i+3,j+4) = 0;
        masked_qr(i+4, j+3) = 0;
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