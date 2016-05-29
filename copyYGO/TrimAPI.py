from base64 import b64encode
from urllib2 import Request, urlopen
import os
import json

def get_fullpath_by_extension(rootdir,extensions=None):
    __re=[]
    for parent,dirnames,filenames in os.walk(rootdir):
        for filename in filenames:
            fullpath=os.path.join(parent,filename)
            
            path_extension=os.path.splitext(fullpath)[1]
            if (extensions and path_extension in extensions) or not extensions:
                result={}
                result="/".join(fullpath.split("\\"))
                __re.append(result)
    return __re

def trim_API(input_path,output_path,key):
    with open(input_path, "rb") as rf:
        requestByte=rf.read()
    request = Request("https://api.tinypng.com/shrink", requestByte)
    cafile = None
    # Uncomment below if you have trouble validating our SSL certificate.
    # Download cacert.pem from: http://curl.haxx.se/ca/cacert.pem
    # cafile = dirname(__file__) + "/cacert.pem"
    sold=("api:" + key).encode("ascii")
    auth = b64encode(sold).decode("ascii")
    request.add_header("Authorization", "Basic %s" % auth)
    response = urlopen(request, cafile = cafile)
    if response.code == 201:
        # Compression was successful, retrieve output from Location header.
        result_url=response.headers["Location"]
        result_info=json.loads(response.read()) 
        input_size=result_info["input"]["size"]
        output_size=result_info["output"]["size"]
        compress=input_size-output_size
        result = urlopen(result_url, cafile = cafile).read()
        format_dict={"input":input_size,"output":output_size,"compress":compress,"path":output_path}
        with open(output_path, "wb") as wf:
            wf.write(result)
        print "before:%(input)s after:%(output)s compress:%(compress)s path:%(path)s" %format_dict
        print "="*50
    else:
        # Something went wrong! You can parse the JSON body for details.
        print("Compression failed")
        
if __name__ == '__main__':
    global use_count
    global total_compress
    global total_input
    global total_output
    use_count=0
    total_compress=0
    total_input=0
    total_output=0
    
    key = "BAo3dvHjhGBtZWm7cdAb9FWfTe3NqaX8"
#     trim_API(input,output,key)
    dir_path="D:/dota_1/LIBRARY/trim/new"
    file_list=get_fullpath_by_extension(dir_path,[".jpg",".png"])



    for path in file_list:
        trim_API(path, path, key)
    print "success"
    format_dict={"count":use_count,"before":total_input,"after":total_output,"compress":total_compress}
    print "Total--> Image:%(count)s before:%(before)s after:%(after)s compress:%(compress)s" %format_dict
#     
    
    