# https://stackoverflow.com/questions/54102980/convert-a-tab-and-newline-delimited-string-to-pandas-dataframe/54103026
# https://www.nltk.org/api/nltk.parse.corenlp.html#module-nltk.parse.corenlp
# https://github.com/nltk/nltk/blob/develop/nltk/parse/corenlp.py

import os, io, re
import pandas as pd
from nltk.parse.corenlp import CoreNLPDependencyParser

# Start server from the root directory of CoreNLP before specifying the following parser
dep_parser = CoreNLPDependencyParser('http://localhost:9001')

# specify the input and output folders which contain all texts and subfolders
indir = 'D:/project/gatsby/texts_seg'
outdir = 'D:/project/gatsby/texts_mdd'

# make a list of the files with their complete paths
infiles = [os.path.join(root, name)
          for root, dirs, files in os.walk(indir)
          for name in files]

# for each file from the input folder, if non-existent, create a corresponding subfolder in the output folder
# work with the file and save the result in the corresponding subfolder of the output folder
col = ['word','pos','gid','wdr']
totaldd = pd.DataFrame(columns = ['id','text','mdd'])        #section average dd
for fname in infiles:
    newfolder = re.sub(indir, outdir, re.sub(r'[^\\]+.txt','',fname))
    if not os.path.exists(newfolder):
        os.makedirs(newfolder)
    dd = pd.DataFrame(columns = ['sid','mdd'])
    n = 1
    f = io.open(fname, 'r', encoding='gb18030')  # encoding='utf-8'
    lines = filter(None, (l.rstrip() for l in f))
    for line in lines:
        parsed_sents = dep_parser.parse_text(line)
        for parsed_sent in parsed_sents:
            pconll = parsed_sent.to_conll(4)
            strl = re.sub('\n$','',pconll).split('\n')
            sent = pd.DataFrame([x.split('\t') for x in strl], columns=col)
            sent['sid'] = n
            sent['wid'] = range(1, len(sent)+1)
            ddf = sent[(sent.wdr!="root") & (sent.wdr!="ROOT") & (sent.wdr!="punct")].copy()
            ddf['dis'] = abs(ddf.wid - ddf.gid.astype(int))
            dd.loc[len(dd)] = [n, ddf.loc[:,"dis"].mean()]
            n += 1
    dd.to_csv(os.path.join(outdir, re.sub(indir,'',re.sub(r'.txt','_mdd.csv',fname))), encoding='gb18030', sep=',', index=False)
    totaldd.loc[len(totaldd)] = [re.sub(indir,'',re.sub(r'\\[^\\]+.txt','',fname)), re.sub(r'.*\\([^\\]+).txt','\\1',fname), dd.loc[:,"mdd"].mean()]
totaldd.to_csv(os.path.join(outdir, 'totaldd.csv'), encoding='gb18030', sep=',',index=False)
