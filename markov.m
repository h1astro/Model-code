function matrix_p=cal_status()
vec1=[1/4,1/4,1/4,1/4];
vec2=[1/10,2/10,3/10,4/10];

%% 验证部分
p1=zeros(4,4);
%第一个矩阵
p1(1,1)=9/10;
p1(1,3)=1/10;
p1(2,2)=9/10;
p1(2,3)=1/10;
p1(3,3)=1;
p1(4,4)=1;
%第二个矩阵
p2=zeros(4,4);
p2(1,1)=1;
p2(2,2)=8/9;
p2(2,4)=1/9;
p2(3,3)=1;
p2(4,4)=1;
%第三个矩阵
p3=zeros(4,4);
p3(1,1)=4/9;
p3(1,4)=5/9;
p3(2,2)=1;
p3(3,3)=1;
p3(4,4)=1;
%相乘
pnew=p1*p2*p3;
vec2new=vec1*pnew;      %最终结果和vec2一样

% load percent_education;
% percent=percent_education;

status=zeros(size(vec1,2),size(vec1,2));
vector1=vec1; %输入第一个向量
vector2=vec2;   %输入第二个向量
vector1_old=vector1; %取2015.9
length_vector1=length(vector1);

matrix_p=eye(length_vector1,length_vector1);
for i=1:length_vector1-1
    matrix_new_p=eye(length_vector1,length_vector1);
    sub_vector=vector2-vector1;
    positive_index=(find(sub_vector>0));
    if isempty(positive_index)==1 || norm(sub_vector)<10e-5
        break;
    end
    [~,min_index]=min(sub_vector(positive_index));
    min_positive_index=positive_index(min_index);
    
    negative_index=(find(sub_vector<0));
    [~,min_index]=max(sub_vector(negative_index));
    min_negative_index=negative_index(min_index);
    half_sub=sub_vector(min_positive_index)/length(negative_index);     %平均负数的数量
    vector1_new=vector1;
    if half_sub<=abs(sub_vector(min_negative_index))            %绝对值,两种情况< ,平均分配给标号为负值的
%         status(min_negative_index,min_positive_index)=half_sub/vector1(min_negative_index);
        vector1_new(negative_index)=vector1_new(negative_index)-half_sub;
        vector1_new(min_positive_index)=vector1_new(min_positive_index)+half_sub*length(negative_index);

        matrix_new_p=zeros(length_vector1,length_vector1);
        matrix_new_p(negative_index,min_positive_index)=half_sub./vector1(negative_index);
        for i_index=1:length_vector1
            matrix_new_p(i_index,i_index)=1-sum(matrix_new_p(i_index,:));
        end
    else
        vector1_new(min_negative_index)=vector1_new(min_negative_index)-abs(sub_vector(min_negative_index));
        vector1_new(min_positive_index)=vector1_new(min_positive_index)+abs(sub_vector(min_negative_index));   
        matrix_new_p(min_negative_index,min_positive_index)=abs(sub_vector(min_negative_index)/vector1(min_negative_index));
        matrix_new_p(min_negative_index,min_negative_index)=1- matrix_new_p(min_negative_index,min_positive_index);
    end
    vector1=vector1_new;
    matrix_p=matrix_p*matrix_new_p;
end
%% 验证
vector1_old*matrix_p
vector2



% end