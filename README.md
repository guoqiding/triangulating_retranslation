# triangulating_retranslation

The codes and data used in our Article "Triangulating text relationship in literary retranslation" are supplied here for the replication of the reported analyses.

First, as nonexperts at all in programming, we have to apologize for the clumsiness and ugliness of the codes we have managed to compile for our purposes. Readers are encouraged to use their own codes or tools so long as the same results can be achieved.

The process of data collection and analyses chiefly consists of the following steps (the beginning numbers in the names of the code files indicating the corresponding steps):

### Step 1: Preprocessing of the texts

The English source text and its nine Chinese translations are obtained from Amazon ebooks, and owing to copyright limitation, we cannot share the full texts here. Interested readers can try to find them based on the publication information provided in the Article (see **Table 1**).

After the original English source text and its nine Chinese translations are split manually into sections (see the Article for the criteria of text splitting and the document info file in the data directory here for word counts of the documents), word segmentation, POS tagging (see [**code 1-1**](https://github.com/guoqiding/triangulating_retranslation/blob/main/codes/1-1%20word_segment_and_pos_tagging.ipynb)) and dependency parsing (see [**code 1-2**](https://github.com/guoqiding/triangulating_retranslation/blob/main/codes/1-2%20calculate_mean_dependency_distance.ipynb)) are conducted separately on the Chinese documents, using Python's nltk package, which prerequires the installation of Stanford CoreNLP (https://stanfordnlp.github.io/CoreNLP/). For more accuracy of word segmentation, a customized dictionary (see mydict.ser.gz in the data directory) is created beforehand by adding proper names (persons, places, etc.) used in the translations to the CoreNLP dictionary (dict-chris6.ser.gz). For information about building a customerized dictionary, see https://nlp.stanford.edu/software/segmenter-faq.html.

### Step 2: Collecting data of linguistic features

Data of 21 linguistic features (see **Table 2** in the Article) are collected from the word-segmented documents and the POS-tagged ones separately. From the former, data of features 1-6 & 18 (see [**code 2-1**](https://github.com/guoqiding/triangulating_retranslation/blob/main/codes/2-1%20collect_data_from_seg_texts.r)) are obtained, and from the latter, 7-17 & 20-21 (see [**code 2-2**](https://github.com/guoqiding/triangulating_retranslation/blob/main/codes/2-2%20collect_data_from_pos_texts.r)), while feature 19 is calculated already in Step 1 (see [**code 1-2**](https://github.com/guoqiding/triangulating_retranslation/blob/main/codes/1-2%20calculate_mean_dependency_distance.ipynb)).

### Step 3: Cluster analysis based on MFWs

The cluster analysis based on most frequent words is done using the stylo library in R (Ver. 4.1.2), with the Classic (aka Burrows's) Delta as the method for distance measurement and with 100, 200, 500, 1000, 1500, and 2000 MFWs separately (see [**code 3**](https://github.com/guoqiding/triangulating_retranslation/blob/main/codes/3%20MFWs-based_ca_analysis_with_stylo.r) and [**Fig. 2**](https://github.com/guoqiding/triangulating_retranslation/blob/main/figures/figure2.tiff) in the Article).

### Step 4: SVM-based classification analyses

SVM-based classification analyses are done using the sklearn package in Python (Ver. 3.10; see [**code 4**](https://github.com/guoqiding/triangulating_retranslation/blob/main/codes/4%20feature_selection_and_accuracy_scores.ipynb)), first with all 21 linguistic features of the nine translations for feature selection (see **Table 3**), and then with 17 effective features for measuring the accuracy of text classification (see **Tables 4 & 5**).

Here we must apologize that we did not set a fixed seed in training the SVM, which is necessary to get absolutely reproducible results. However, results similar to what is reported in our study can be easily reproduced either by using the default random sampling or by setting any particular seed.

### Step 5. Principal components analysis (PCA)

PVA analyses are done based on the 17 linguistic features of the nine translations, using the FactoMineR and factoextra libraries in R (Ver. 4.1.2; see [**Fig. 3**](https://github.com/guoqiding/triangulating_retranslation/blob/main/figures/figure3.tiff), **Table 6** & [**code 5**](https://github.com/guoqiding/triangulating_retranslation/blob/main/codes/5%20pca_analyses.r)).

### Step 6. Feature-based contrast and distance calculation

A visualization is done based on the normalization (zscores) of the mean values for the 17 features of the nine translations (see [**Fig. 4**](https://github.com/guoqiding/triangulating_retranslation/blob/main/figures/figure4.tiff) and [**code 6-1**](https://github.com/guoqiding/triangulating_retranslation/blob/main/codes/6-1%20features_zscore_barplot.r)). The Euclidean distances between translations is thereby calculated (see **Table 7** and [**code 6-2**](https://github.com/guoqiding/triangulating_retranslation/blob/main/codes/6-2%20feature-based_distances.r)).

### Step 7. Sentiment analysis

For sentiment analyses, calculations of sentence sentiments are conducted separately for the English source text and its nine translations (see [**code 7-1**](https://github.com/guoqiding/triangulating_retranslation/blob/main/codes/7-1%20calculate_sentence_sentiment.r)). For technical reasons, we opt for the lexicon-based approach. For the English text, we use the lexicon that comes with the R sentimentr library, while for Chinese texts, a workable Chinese sentiment lexicon is compiled (see the Article for details), which can be found in the worlists directory.

With the raw sentiment data, plots are made using methods of sampling and rescaling to show the plot structure of the texts (see [**Fig. 1**](https://github.com/guoqiding/triangulating_retranslation/blob/main/figures/figure1.tif)) and, in some sense, also the promity of translations to the source text (see [**Fig. 5**](https://github.com/guoqiding/triangulating_retranslation/blob/main/figures/figure5.tiff) & [**code 7-2**](https://github.com/guoqiding/triangulating_retranslation/blob/main/codes/7-2%20plot_sentiment_of_source_text_and_translations.r)). The Euclidean distance between the source text and the translations is then calculated based on the sampled and resclaed data (see **Table 8** & [**code 7-3**](https://github.com/guoqiding/triangulating_retranslation/blob/main/codes/7-3%20sentiment-based_distances.r)).

Finally, we wish you good luck if you are interested in replicating the results reported in the Article.
