<!--#include virtual="/manager/config/config.asp" -->
<!--#include virtual="/config/uercheck.asp" -->
<%
conn.open constr
id=requesta("id")
If Not isnumeric(id&"")  Then id=0
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<HEAD>
<title>�û������̨-�ƽ�վ����</title>
<META http-equiv=Content-Type content="text/html; charset=gb2312">
   <link rel="stylesheet" href="/template/Tpl_2016/css/global.css">
   <link rel="stylesheet" href="/template/Tpl_2016/css/common.css">
   <link rel="stylesheet" href="/manager/css/2016/manager-new.css">
   <script type="text/javascript" src="/template/Tpl_2016/jscripts/jquery-1.11.3.min.js"></script>
 
</HEAD>
<body>
  <!--#include virtual="/manager/top.asp" -->
  <div id="MainContentDIV">
      <!--#include virtual="/manager/manageleft.asp" -->
     <div id="ManagerRight" class="ManagerRightShow">
		 <div id="SiteMapPath">
			 <ul>
			   <li><a href="/">��ҳ</a></li>
			   <li><a href="/Manager/">��������</a></li>
			   <li>��������</li>
			 </ul>
		  </div>

             
<div class="panel">
                    <div class="panel-title"><span class="txt">վ����ϸ��Ϣ</span></div>
                    <div class="panel-content">
				<table class="manager-table">
					<tr>
						<th width=15% align="right">վ�����ͣ�</th>
						<td id="zdlx" width="35%"></td>
						<th width="15%" align="right">CNAME������</th>
						<td id="cnamejx"  width="35%"></td>
					</tr>
					<tr>
						<th align="right">���Ե�ַ��</th>
						<td></td>
						<th align="right">�����룺</th>
						<td></td>
					</tr>

				</table>
 
                        <div class="product-detail-desc mt-30">
                            <div class="title">
                                <span>��ܰ��ʾ</span>
                            </div>
                            <ol class="pdd-list">
                                <li>
                                    ��վģ������󣬲���������Ч��һ��24Сʱ֮����Ч��
                                </li>
                                <li>
                                    ��¼���������̨�޸�����վ�������ƻ��߹��������������ˢ�¡���ť���»�ȡһ�����ݡ�
                                </li>
                                <li>
                                    ������ҳ��վ����Ϣ����������ˢ�¡���ť���»�ȡһ���������ݡ�
                                </li>
                                <li>
                                    ΢С�꽨վ���Ͳ��ܸ���ģ�壬��ʹ�õ�ģ��Ϊ����ģ�壬��ģ��id�޷���ģ���б��в�ѯ����
                                </li>
                                <li>
                                    ������ģ�塱�г���Ϊ��ǰ��վ�Ѿ�����ľ�Ʒģ��id�б��������ڵ�ǰվ�㣬����������������վ�㡣
                                </li>
                                <li>
                                    ģ�幦�ܷ�Ϊ�����������ͣ���׼�����ͣ�Ӫ�������ͣ��ȼ��������ߣ��͵ȼ��Ľ�վ��Ʒ����ʹ�øߵȼ���ģ�塣
                                </li>
                            </ol>
                        </div>
                    </div>
                </div>






 
	 </div>

  </div>


 <!--#include virtual="/manager/bottom.asp" -->
</body>
</html>