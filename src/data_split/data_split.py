import os
from langchain_community.document_loaders import PyPDFLoader   
from langchain_text_splitters import RecursiveCharacterTextSplitter

#2. Define the data source and load data with PDFLoader(https://www.upl-ltd.com/images/people/downloads/Leave-Policy-India.pdf)
data_load=PyPDFLoader('https://www.upl-ltd.com/images/people/downloads/Leave-Policy-India.pdf')
#3. Split the Text based on Character, Tokens etc. - Recursively split by character - ["\n\n", "\n", " ", ""]
data_split=RecursiveCharacterTextSplitter(separators=["\n\n", "\n", " ", ""], chunk_size=100,chunk_overlap=10)
data_sample = 'Welcome to the most comprehensive AWS Cloud Development Kit (CDK) with actual enterprise hands-on implementation experience migrating large number of workloads using AWS CDK V2.'
data_split_test = data_split.split_text(data_sample)
print(data_split_test)