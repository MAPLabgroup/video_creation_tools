function IM2AVI(path, ext)

% takes str 'path' full of images of extension str 'ext', and spits out an
% avi file the name of the first file. images must be named in a deliberate
% so as to get correct ordering

% ext can be gif, png, tiff, jpg, jpeg, bmp and others (see imread)

% this version is designed to work for images numbered as "a01, a02, ...,
% a10, a11" NOT for "a1, a2, ..., a10, a11" - for the second option, see
% "IM2AVI"

% NOTE: indeo5 is a deprecated codec. Be sure to set the codec, fps,
% quality, etc under avifile command below

path = char(path);
ext = char(ext);

a = dir(fullfile(path, ['*.' ext]));

if isempty(a)
    fprintf('no files with this extension\n');
    return;
end



for i = 1:length(a)
    
    IM = imread(fullfile(path, a(i).name));
    map = colormap(jet);
    if ~exist('aviobj')
        aviobj = avifile(['movie.avi'], 'fps', 12, ...
            'compression', 'Indeo5', 'colormap', map, 'quality', 60);
    end
    
    aviobj = addframe(aviobj, IM);
    
end

aviobj=close(aviobj);