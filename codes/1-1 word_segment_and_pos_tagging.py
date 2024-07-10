# Import packages

import os
import re
import io

# Start server from the root directory of CoreNLP before specifying the following tools
from nltk.parse.corenlp import CoreNLPParser

parser = CoreNLPParser(url='http://localhost:9001', tagtype='pos')

# specify the input and output master folders which contain all texts and subfolders
indir = 'D:/project/gatsby/texts'
outdir1 = 'D:/project/gatsby/texts_seg'
outdir2 = 'D:/project/gatsby/texts_pos'

# make a list of the files with their complete paths
infiles = [os.path.join(root, name)
          for root, dirs, files in os.walk(indir)
          for name in files]

# for each file from the input folder, if non-existent, create a corresponding subfolder in the output folder
# work with the file and save the result in the corresponding subfolder of the output folder
for fname in infiles:
    infile = io.open(fname, 'r', encoding='gb18030')
    newfolder1 = re.sub(indir, outdir1, re.sub(r'[^\\]+.txt','',fname))
    if not os.path.exists(newfolder1):
        os.makedirs(newfolder1)
    newfolder2 = re.sub(indir, outdir2, re.sub(r'[^\\]+.txt','',fname))
    if not os.path.exists(newfolder2):
        os.makedirs(newfolder2)
    result1 = io.open(re.sub(indir, outdir1, fname), 'w', encoding='gb18030')
    result2 = io.open(re.sub(indir, outdir2, fname), 'w', encoding='gb18030')
    print ('Writing file: '+fname+'')
    lines = filter(None, (line.rstrip() for line in infile))
    for line in lines:
        seg = parser.tokenize(line)
        output1 = ' '.join(x for x in seg)
        result1.write(output1 + '\r\n')
        pos = parser.tag(line.split())
        output2 = ' '.join(list('_'.join(x) for x in pos))
        result2.write(output2 + '\r\n')

    infile.close()
    result1.close()
    result2.close()