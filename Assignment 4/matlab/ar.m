% Q5
close all;
clear all;

% calculated by counting the number of 0 rows in an arbitrary frame (10) [padding is about 44 pixels in vertical space]
video_pad_remove = 45;

book_vid = loadVid("../data/book.mov");
source_vid = loadVid("../data/ar_source.mov");

% measuring height by exclulding the black padding pixels
[source_height, source_width, ~] = size(source_vid(1).cdata(video_pad_remove:end-video_pad_remove, :, :));

book_image = imread("../data/cv_cover.jpg");
book_image = imresize(book_image, source_height / size(book_image, 1));				% resize book to source

[book_height, book_width] = size(book_image);
block_width = round((source_width - book_width) / 2);								% size of block (width selection)
frame_num = 1;

writer = VideoWriter("../results/KungFuPanda_book", "Motion JPEG AVI");
open(writer);

%% Book Video (641 vs 511) has more frames of video (so using source video)
while frame_num <= size(source_vid, 2)
	book_frame = book_vid(frame_num).cdata;
	source_frame = source_vid(frame_num).cdata;

	source_frame = source_frame(video_pad_remove:end-video_pad_remove, :, :);		% removing black bars
	source_frame = source_frame(:, block_width:source_width-block_width, :);		% width selection

	[locs1, locs2] = matchPics(book_image, book_frame);
	[bestH2to1, ~] = computeH_ransac(locs1, locs2);
	composite_img = compositeH(bestH2to1, source_frame, book_frame);
	% imshow(composite_img);
	writeVideo(writer, composite_img);
	frame_num = frame_num + 1;
end
close(writer);