#!/bin/bash
ProductName=gtgo


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
  newVersionNo="${new// /.}"
}


fileVersionLineNo=`cat ./package.json | grep -n "version" | awk -F ":" '{print $1}'`
OldVersionNo=`cat ./package.json | grep -n "version" | awk -F ":" '{print $3}' | sed 's/\"//g' | sed 's/,//g' | sed 's/ //g'`
newVersionNo=$OldVersionNo
incrementVersion ${OldVersionNo}

echo $fileVersionLineNo
echo $OldVersionNo
echo $newVersionNo

sed -i "" -e "${fileVersionLineNo}s/$OldVersionNo/$newVersionNo/g" package.json 

npm install && git add . && git commit -m "v"$newVersionNo & git tag v${newVersionNo} && git push --tags && git push
