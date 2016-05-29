# -*- coding: UTF-8 -*-
'''
Created on 2016年1月14日

@author: Administrator
'''
import os
import web
import shutil

def get_fullpath_by_extension(rootdir,extensions=None):
    __re=[]
    for parent,dirnames,filenames in os.walk(rootdir):
        for filename in filenames:
            fullpath=os.path.join(parent,filename)
            if os.path.dirname(fullpath).count(".")!=0:
                continue
            path_extension=os.path.splitext(fullpath)[1]
            if (extensions and path_extension in extensions) or not extensions:
                result=fullpath.replace("\\","/")
                __re.append(result)
    return __re


def create():
    db = web.database(dbn='sqlite',db="cards.cdb")
    return db

def search_id():
    result=create().select('datas')
    result=list(result)
    if bool(result):
        return result;
    else:
        return [];

input_path="D:/thumbnailBase"
output_path="D:/thumbnail"
if __name__ == '__main__':
#     jpg_list=get_fullpath_by_extension(input_path,[".jpg"])
#     print(os.path.split(jpg_list[0]))
    result=search_id()
    result=[x.get("id") for x in result]
    for x in result:
        source_path=input_path+"/"+str(x)+".jpg"
        target_path=output_path+"/"+str(x)+".jpg"
        if os.path.exists(source_path):
            shutil.move(source_path, target_path)
        else:
            print(source_path)