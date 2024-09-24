# %% [markdown]
#  #### Import libraries

# %%
# %%
import pandas as pd


# %%
# %%
meta = pd.read_csv('filtered_metadata.tsv', sep='\t')


# %%
# %%
meta['PHYLUM'] = 'Ascomycota'


# %%
# %%
column_list = meta.columns.tolist()
column_list.remove('Organism Name')
column_list.remove('PHYLUM')


# %%
# %%
samples = meta.drop(columns=column_list)
samples.columns = samples.columns.str.replace(' ', '_')
samples['Organism_Name'] = samples['Organism_Name'].str.replace(' ', '_')


# %%
# %%
samples.to_csv('samples.csv', index=False)





