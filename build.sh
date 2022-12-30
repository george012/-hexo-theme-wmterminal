#!/bin/bash
ProductName=wmterminal


# 递增版本号
incrementVersion () {
  declare -a part=( ${1//\./ } )
  declare    new
  declare -i carry=1 #递增量

  for (( CNTR=${#part[@]}-1; CNTR>=0; CNTR-=1 )); do
    len=${#part[CNTR]}
    new=$((part[CNTR]+carry))
    [ ${#new} -gt $len ] && carry=1 || carry=0
    [ $CNTR -gt 0 ] && part[CNTR]=${new: -len} || part[CNTR]=${new}
  done
  new="${part[*]}"
  NewVersion="${new// /.}"
}


ParseJson(){
    echo "${1//\"/}" | sed "s/.*$2:\([^,}]*\).*/\1/"
}

PakageJson=`cat ./package.json`
Value=`echo $PakageJson | sed s/[[:space:]]//g`
Oldversion=$(ParseJson $Value "version")
NewVersion=${Oldversion}
incrementVersion ${Oldversion:0,0}


fileVersionLineNo=`cat ./package.json | grep -n '"version":' | awk -F ":" '{print $1}'`
oldfileVersionStr=`cat ./package.json | grep -n '"version":' | awk -F ":" '{print $3}'`

newVersionStr='"'$NewVersion'"'

echo $fileVersionLineNo
echo $oldfileVersionStr
echo $newVersionStr

# sed -i "" -e "${fileVersionLineNo}s/'${oldfileVersionStr}'/$newVersionStr/g" ./package.json

sed -i "" -e 's/\("version":"\).*/\1'"${NewVersion}"'",/g' ./package.json

# oldTags=`git tag -l |grep -v ${gitLastTagVersion}`
# git push origin --delete $oldTags && git tag -d $oldTags &&  git add . && git commit -m "v"$newVersionNo && git push && git tag v${newVersionNo} && git push --tags
