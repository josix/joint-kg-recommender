import torch

with open("transup-kktix-128-0.001000-256-5-0.950000-no_early_stop_steps-200000.emb", 'rb') as fin:
    all_emb = torch.load(fin)
    # odict_keys(['user_embeddings.weight', 'item_embeddings.weight', 'pref_embeddings.weight', 'pref_norm_embeddings.weight', 'ent_embeddings.weight', 'rel_embeddings.weight', 'norm_embeddings.weight'])

index_id_to_item_id = {}
with open("../datasets/kktix/i_map.dat") as fin:
    for line in fin:
        index_id, item_id = line.strip().split('\t')
        index_id_to_item_id[int(index_id)] = item_id

index_id_to_user_id = {}
with open("../datasets/kktix/u_map.dat") as fin:
    for line in fin:
        index_id, user_id = line.strip().split('\t')
        index_id_to_user_id[int(index_id)] = user_id

with open('transup-kktix-128-0.001000-256-5-0.950000-no_early_stop_steps-200000-pronetfmt.emb', 'wt') as fout:
    for idx, emb in enumerate(all_emb["user_embeddings.weight"]):
        fout.write("{} {}\n".format(index_id_to_user_id[idx], " ".join([ "{:.7f}".format(x) for x in emb.tolist()])))
    for idx, emb in enumerate(all_emb["item_embeddings.weight"]):
        fout.write("{} {}\n".format(index_id_to_item_id[idx], " ".join([ "{:.7f}".format(x) for x in emb.tolist()])))
