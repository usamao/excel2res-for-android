# excel2res-for-android

Tool to convert excel file to string resources for Android.  
This tool converts xlsx directly on Mac.  
So you don't have to create csv file on ahead.

## How to use

1. Open excel sheet which you want to convert
1. Execute excel2res.app
1. Select output directory in GUI

## Excel sheet format

Sample is here.

| ID       | English | Spanish | Japanese | Description               |
|:---------|:--------|:--------|:---------|:--------------------------|
| id       | defalut | es      | ja       |                           |
| id_hello | hello   | hola    | こんにちは | an expression of greeting |

First row is not related to conversion, but for only labeling.  
If the cell in second row is `id`, the cells in its column represent resource id.  
If the cell in second row is `default`, string resource will be created in `value` directory.  
If the cell in second row is language code, string resource will be created in `value-xx` directory.  
If the cell in second row is empty, the cells in its column are ignored to convert.  
Please refer to [sample.xlsx](https://github.com/usamao/excel2res-for-android/blob/master/sample.xlsx).

## XML escaping

Following characters will be replaced.


| Character | Replaced |
|:----------|:---------|
| <         | `&lt;`   |
| >         | `&gt;`   |  
| &         | `&amp;`  |
| '         | `\'`     |
| "         | `\"`     |
