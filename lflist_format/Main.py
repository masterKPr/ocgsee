# -*- coding: UTF-8 -*-
'''
Created on 2016年1月18日

@author: Administrator
'''
import json


if __name__ == '__main__':
    title=""
    head=""
    lf_dict={}
    with open("lflist.conf") as f:
        for line in f:
            line=line.strip()
            if not line:
                continue
            if line[0]=="!":
                title=line[1:]
            elif line[0]=="#":
                head=line[1:]
            else:
                if title=="" and head=="":
                    continue
                card_num=line.split("--")[0]
                card_num=card_num.strip()
                card_id=card_num.split(" ")[0]
                if not lf_dict.has_key(title):
                    lf_dict[title]={}
                if not lf_dict[title].has_key(head):
                    lf_dict[title][head]=[]
                lf_dict[title][head].append(card_id)
                
    for key in lf_dict:
        st=key.decode("utf-8")
        file_name="config/{0}.json".decode("utf-8").format(st)
        with open(file_name,"w") as f:
            result_str=json.dumps(lf_dict[key])
            result_str=",\n".join(result_str.split(","))
            result_str="[\n".join(result_str.split("["))
            f.write(result_str)
            
                
                
                
