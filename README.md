# triangulating_retranslation

The codes and data used in our Article "Triangulating text relationship in literary retranslation" are supplied here for the replication of the reported analyses.

First, as nonexperts at all in programming, we have to apologize for the clumsiness and ugliness of the codes we have managed to compile for our purposes. Readers are encouraged to use their own codes or tools so long as the same results can be achieved.

The process of data collection and analyses chiefly consists of the following steps (the beginning numbers in the names of the code files indicating the corresponding steps):

Step 1: Preprocessing of the texts

After the original English source text and its nine Chinese translations are split manually into sections (see the Article for the criteria of text splitting and the document info file in the data directory here for word counts of the documents), word segmentation, POS tagging (see code 1-1) and dependency parsing (see code 1-2) are conducted separately on the Chinese documents, using Python's nltk package, which prerequires the installation of Stanford CoreNLP (https://stanfordnlp.github.io/CoreNLP/). For more accuracy of word segmentation, a customized dictionary (see mydict.ser.gz in the data directory) is created beforehand by adding proper names (persons, places, etc.) used in the translations to the CoreNLP dictionary (dict-chris6.ser.gz). For information about building a customerized dictionary, see https://nlp.stanford.edu/software/segmenter-faq.html.

The English source text and its nine Chinese translations are obtained from Amazon ebooks, and owing to copyright limitation, we cannot share the full texts here. Interested readers can try to find them based on the publication information provided in the Article (see Table 1).

Step 2: Collecting data of linguistic features

Data of 21 linguistic features (see Table 2 in the Article) are collected from the word-segmented documents and the POS-tagged ones separately. From the former, data of features 1-6 & 18 (see code 2-1) are obtained, and from the latter, 7-17 & 20-21 (see code 2-2), while feature 19 is measured alone (see code 2-3).

Step 3: Cluster analysis based on MFWs

The cluster analysis based on most frequent words is done using the stylo library in R (Ver. 4.1.2), with the Classic (aka Burrows's) Delta as the method for distance measurement and with 100, 200, 500, 1000, 1500, and 2000 MFWs separately (see code 3 and Fig. 2 in the Article).

Step 4: SVM-based classification analyses

SVM-based classification analyses are done using the sklearn package in Python (Ver. 3.10), first with all 21 linguistic features of the nine translations for feature selection (see Table 3 & code 4-1), and then with 17 effective features for measuring the accuracy of text classification (see Tables 4 & 5 & code 4-2).

Step 5. Principal components analysis (PCA)

PVA analyses are done based on the 17 linguistic features of the nine translations, using the FactoMineR and factoextra libraries in R (Ver. 4.1.2; see Fig. 3, Table 6 & code 5).

Step 6. Feature-based contrast and distance calculation

The calculation of Euclidean distance between translations is done based on the normalization (zscores) of the mean values for the 17 features of the nine translations (see Table 7, Fig. 4 & code 6).

Step 7. Sentiment analysis

For sentiment analyses, calculations of sentence sentiments are conducted separately for the English source text (see code 7-1) and its nine translations (see code 7-2). For technical reasons, we opt for the lexicon-based approach. For the English text, we use the lexicon that comes with the R sentimentr library, while for Chinese texts, a workable Chinese sentiment lexicon is compiled (see the Article for details), which can be found in the worlists directory.

With the raw sentiment data, plots are made using methods of sampling and rescaling to show the plot structure of the texts (see Fig. 1 & code 7-3) and, in some sense, also the promity of translations to the source text (see Fig. 5 & code 7-4). The Euclidean distance between the source text and the translations is then calculated based on the sampled and resclaed data (see Table 8 & code 7-5).

Finally, we wish you good luck if you are interested in replicating the results reported in the Article.
