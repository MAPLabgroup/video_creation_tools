function IM2AVI(path, ext, format, fout_format)

% takes str 'path' full of images of extension str 'ext', and spits out an
% avi file the name of the first file. images must be named in a deliberate
% so as to get correct ordering

% this version is designed to work for images numbered as "a1, a2, ...,
% a10, a11" NOT for "a01, a02, ..., a10, a11" - for the second option, see
% "IM2AVI_alternative"

% format should yield a number so that we can sort the images.

% ext can be gif, png, tiff, jpg, jpeg, bmp and others (see imread)

% NOTE: indeo5 is a deprecated codec. Be sure to set the codec, fps,
% quality, etc under avifile command below

%example syntax: IM2AVI('C:\Documents and Settings\Thackery
%Brown\Desktop\demoimages\f', 'jpg', '%*c %d *c', '%c *' )

% Thackery Brown and Andrew Bogaard 24 feb 2010

a = dir(fullfile(path, ['*.' ext]));

if exist('format', 'var')
    
    order = cellfun(@(c) sscanf(c, format), {a.name});
    
    [tmp, order] = sort(order);
    
else
    
    order = 1:length(a);
    
end

if nargin<4
    
    fout = 'movie.avi';
    
else
    
    fout = [sscanf(a(order(1)).name, fout_format) '.avi'];
end

if isempty(a)
    fprintf('no files with this extension\n');
    return;
end

for i = 1:length(order)
    
    % DivX has several restrictions: image width must be a multiple of 4, 
  % height must be a multiple of 2 and the image data must be three channel 
      % uint8. I these requirements are not met you will get the "Failed to set 
    % stream format" error.
    
    IM = imread(fullfile(path, a(order(i)).name));
    map=colormap(jet);
    if ~exist('aviobj')
        aviobj = avifile(fullfile(path, fout),...
            'compression', 'indeo5', 'fps', 15, 'quality', 90);
    end

    aviobj = addframe(aviobj, IM);
    
end

aviobj=close(aviobj);