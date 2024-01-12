# Explore_NLP
Natural Language Processing Coursework

## Contents
<h3 align="center">Text Normalization </h3>
<h3 align="center">Topic Modelling </h3>
<h3 align="center">Named Entity Resolution[NER] </h3>
<h3 align="center">Web Scraping and Text Extraction</h3>
<h3 align="center">Transformers </h3>
<h3 align="center">BERT </h3>
<h3 align="center">LangChain </h3>
<h3 align="center">Vector Databases </h3>
<h3 align="center">Facebook's Atlas RAG Models - Finetuning and Evaluation </h3>


Atlas is an advanced machine learning model which is based on retrieval-augmented language models. In essence, it combines the best features of generative AI models and retrieval-based models. The retrieval component of Atlas RAG is in charge of locating relevant data or evidence within a substantial data set or knowledge base. To do this, it employs a method known as "dense retrieval" to comb through the information. The query and document embedding representations in the dataset serve as a basis for this retrieval. Upon receiving a query, which can be either a question or a prompt, the retrieval model searches and identifies the most relevant passages or documents that could assist in generating a suitable answer. Once relevant documents are retrieved, the generative component of Atlas RAG comes into the picture which is a large language model called T5. The generative model also known as the reader takes the input query and the retrieved documents as inputs and generates a response. The presence of retrieved documents helps the model to produce more accurate, relevant, and informed responses. It's like the model has access to a curated set of information specifically for the given query. The best thing about the Atlas is that it has a lot of information already in its language model parameters because it is built on a pre-trained language model. Hence, Atlas can produce impressively good results with very few examples or even instructions. Learning how to solve the Q&A challenge simply takes some fine-tuning on a few samples. Furthermore, Atlas generates more factual responses due to its retrieval component, in contrast to solely parametric approaches based on large language models. To put it briefly, Atlas is a combination of the best retrieval and generative models that generate answers that are more accurate and contextually relevant. It only needs some fine-tuning and a few-shot learning strategies to function well for our question-answering tasks, including natural questions, multiple-choice questions as well and fact-checking.



