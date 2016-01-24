# -*- coding: UTF-8 -*-
'''
Created on 2016年1月24日

@author: Administrator
'''
import os
import json


def get_fullpath_by_extension(rootdir,extensions=None):
    __re=[]
    for parent,dirnames,filenames in os.walk(rootdir):
        for filename in filenames:
            fullpath=os.path.join(parent,filename)
            path_extension=os.path.splitext(fullpath)[1]
            extensions_status=(extensions and path_extension in extensions) or not extensions
            if extensions_status :
                result=fullpath.replace("\\", "/")
                __re.append(result)
    return __re

if __name__ == '__main__':
    li=get_fullpath_by_extension("config/save")
    for x in li:
        with open(x,"r") as f:
            name=os.path.split(x)[1].decode("gbk")
            name=os.path.splitext(name)[0]
            st=f.read()
            obj=json.loads(st)
            
            key=obj.get("title")
            obj["title"]=name
            print(name)
            st=json.dumps(obj)

        with open(x,"w") as f:
            f.write(st)
