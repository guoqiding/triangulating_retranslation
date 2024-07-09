# triangulating_retranslation

The codes and data used in our Article "Triangulating text relationship in literary retranslation" are supplied here for the replication of the reported analyses.

First, as nonexperts at all in programming, we have to apologize for the clumsiness and ugliness of the codes we have managed to compile for our purposes. Readers are encouraged to use their own codes or tools so long as the same results can be achieved.

The process of data collection and analyses chiefly consists of the following steps (the beginning numbers in the names of the code files indicating the corresponding steps):

Step 1: Preprocessing of the texts

After the original English source text and its nine Chinese translations are split manually into sections (see the Article for the criteria of text splitting and the document info file in the data directory here for word counts of the documents), word segmentation, POS tagging and dependency parsing are conducted separately on the Chinese documents, using Python's nltk package, which prerequires the installation of Stanford CoreNLP (https://stanfordnlp.github.io/CoreNLP/).

The English source text and its nine Chinese translations are obtained from Amazon ebooks, and owing to copyright limitation, we cannot share the full texts here. Interested readers can try to find them based on the publication information provided in the Article.

Step 2: Collecting linguistic features


Step 3: Cluster analysis based on MFWs

Step 4: SVM-based classification analysis

Step 5. Principal components analysis (PCA)

Step 6. Sentiment analysis
