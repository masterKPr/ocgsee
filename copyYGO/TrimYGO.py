# -*- coding: UTF-8 -*-
'''
Created on 2015年12月1日

@author: Administrator
'''
import os
from hashlib import md5
import TrimAPI

def md5_file(path):
    with open(path,"rb") as f:
        m=md5()
        m.update(f.read())
        return m.hexdigest()
    
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

class Trim_log:
    def __init__(self,path):
        self.log_dict={}
        self.count=0
        with open(path) as f:
            for x in f:
                line=x.strip()
                key,value=x.split("&&&")
                value="".join(value.split("\n"))
                self.log_dict[key]=value
                self.count+=1
    
    def hasTrim(self,path):
        if path in self.log_dict:
            path_md5=md5_file(path)
            return self.log_dict[path]==path_md5
        else:
            return False
        
trim_key = "OgilCwxuFL2mubd3nvk-9Ud0UmKVBICQ"
sourcePath="D:/thumbnail"
log_path = "tiny.log"
if __name__ == '__main__':
    if not os.path.exists(log_path):
        with open(log_path,"w") as f:
            pass
    log_cache=Trim_log(log_path)
    count=0
    source_list=get_fullpath_by_extension(sourcePath,[".jpg"])
    source_list=[{"path":x,"size":os.path.getsize(x)} for x in source_list]
    source_list=sorted(source_list,key=lambda x:x.get("size"),reverse=True)
    for x in source_list:
        path=x.get("path")
        if not log_cache.hasTrim(path):
            print path
            TrimAPI.trim_API(path,path,trim_key)
            line="{path}&&&{md5}\n".format(path=path,md5=md5_file(path),size=os.path.getsize(path))
            with open(log_path,"a") as f:
                f.write(line)
            count+=1
            print count+log_cache.count
#             if count+log_cache.count>=900:
#                 exit()
        else:
            print "already trim",path
    
    
    
    