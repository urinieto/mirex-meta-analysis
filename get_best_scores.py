import glob
import os
import pandas as pd
from tqdm import tqdm
from collections import defaultdict

PATH = "./mirex_data"
METRICS = ["F_0.5", "F_3", "F_p", "F_nce"]
RES = {}
RES["mrx09"] = {x: 0 for x in METRICS}
RES["mrx10_1"] = {x: 0 for x in METRICS}
RES["mrx10_2"] = {x: 0 for x in METRICS}
RES["salami"] = {x: 0 for x in METRICS}
STD = defaultdict(dict)
NAMES = defaultdict(dict)


def f_measure(p, r):
    return 2 * p * r / (p + r)


def update_dicts(metric, mean, std, ds, algo, year):
    ds = "salami" if ds == "sal" else ds
    if ds == "mrx10_1" and (metric == "F_nce" or metric == "F_p"):
        # Do not store labeling results for mrx10_1 dataset
        return
    if mean > RES[ds][metric]:
        RES[ds][metric] = mean
        STD[ds][metric] = std
        NAMES[ds][metric] = f"{algo}_{year}"


def process_summary(summary_file):
    _, _, year, ds, algo, _ = summary_file.split("/")
    df = pd.read_csv(summary_file)
    df.columns = ["fold", "track", "nce_o", "nce_u", "F_p", "P_p", "R_p", "rci",
                  "F_0.5", "P_0.5", "R_0.5", "F_3", "P_3", "R_3", "M_ap", "M_pa"]
    df["F_nce"] = df.apply(lambda x: f_measure(x["nce_o"], x["nce_u"]), axis=1)
    mean = df.mean()
    std = df.std()
    for metric in METRICS:
        update_dicts(metric, mean[metric], std[metric], ds, algo, year)


def main():
    all_summaries = glob.glob(os.path.join(PATH, "*", "*", "*", "per_track_results.csv"))
    for summary_file in tqdm(all_summaries):
        process_summary(summary_file)
    print(RES)
    print(STD)
    print(NAMES)


if __name__ == "__main__":
    main()
