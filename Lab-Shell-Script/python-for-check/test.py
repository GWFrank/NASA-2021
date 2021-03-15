import re
sid=input()
num=input()
all_data=input()
all_data_list=all_data.split(' ')
# print(num)
# print(all_data[0])
float_re="([+-]?[0-9]+\.?|[+-]?[0-9]*\.[0-9]{1,6})"
total_re="^"+float_re+f"( {float_re})"*(int(num)-1)+"$"
# print(total_re)
print(re.match(total_re, all_data).group())
# for d in all_data:
#     s=re.match(, d).group()
#     if s == '':
#         print(d)
# for d in all_data:
#     if re.match(d)