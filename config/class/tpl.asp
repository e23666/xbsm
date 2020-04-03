
<style  type="text/css">
  .layui-form-label{
    width:150px
  }

  .layui-input-block{
    margin-left:180px;
  }
  .seachitem{ margin-right:0!important}
  .imgerror{
    border-color:  #FF5722!important;   
  }
  .layui-form-checked.layui-checkbox-disbaled span {
    background-color: #5FB878!important;
  }
</style>

<script id="audittab_tmp" type="text/html">
  <ul id="audittab" class="layui-tab-title" style="margin:10px 5px 20px 5px">
    <li data-tmp="lb" {{if tab=="lb"}} class="layui-this" {{/if}}>ģ���б�</li>
    <li data-tmp="tj" {{if tab=="tj"}} class="layui-this" {{/if}}>���ģ��</li>
    <li data-tmp="gh" {{if tab=="gh"}} class="layui-this" {{/if}}>ģ�����</li>
    <li data-tmp="zt" {{if tab=="zt"}} class="layui-this" {{/if}}>����״̬</li>
  </ul>
</script>
<script id="lbbody_tmp" type="text/html">
   {{if data.info.length>0}}
    <table lay-filter="lbbodytable" >
        <thead>
        <tr>
            <th lay-data="{field:'c_sysid',width:90,sort: true}">���</th>
            <th lay-data="{field:'regtypename',width:100,sort: true}">����</th>
            <th lay-data="{field:'c_org_m',width:255,sort: true}">������</th>
            <th lay-data="{field:'c_em',width:190,sort: true}">����������</th>  
            <th lay-data="{field:'regcontacttype',width:300,sort: true}">���÷�Χ</th>                 <th lay-data="{field:'c_date',width:120,sort: true}">���ʱ��</th>
            <th lay-data="{field:'status',width:180,sort: true,fixed:'right'}">״̬</th>
            <th lay-data="{field:'btn',width:300,align:'right',fixed:'right'}">����</th>    
        </tr> 
        </thead>
        <tbody>    
        {{each data.info}}
        <tr>
            <td>{{$value.c_sysid}}</td>
            <td>{{$value.regtypename}}</td>
            <td>{{$value.c_org_m}}</td>
            <td>{{$value.c_em}}</td> 
            <td> &nbsp;
            {{set t=$value;t.cfg=$data.cfg}}
            {{include 'regcontacttype_tmp' t}}</td>
            <td>{{$value.c_date}}</td>
            <td>
            <div class="layui-btn-group">
            {{include 'statuslist_tmp' $value}}{{include 'statuslistr_tmp' t}}
            </div>
            </td>                 
            <td  style="text-align:right;white-space:nowrap;">
                <input type="checkbox" name="defaultbtn" lay-filter="defaultbtn" data-regtype="{{$value.regtypename}}"  data-id="{{$value.c_sysid}}" {{if $value.isdefault=="1"}}checked{{/if}} title="Ĭ��">
                <div class="layui-btn-group">
                    <button type="button" name="modlbbtn" data-id="{{$value.c_sysid}}" class="layui-btn layui-btn-sm layui-btn-normal">�༭</button>
                    <button type="button" name="domainlbbtn" data-id="{{$value.c_sysid}}"  data-org="{{$value.c_org_m}}" class="layui-btn layui-btn-sm layui-btn-disabled" disabled="true">��������</button>
                    <button type="button" name="dellbbtn" data-id="{{$value.c_sysid}}" class="layui-btn layui-btn-sm  layui-btn-primary layui-btn-disabled"  disabled="true">ɾ��</button>   
                </div>   
            </td>
        </tr>  
        {{/each}}     
        </tbody>
    </table>
    <div id="pagebox_mg"></div>
   {{else}}
    <div class="msg-box warn-msg-box">
        <i class="msg-icon"></i>���κμ�¼
    </div>    
    {{/if}}  
</script>
<script id="lbsearch_tmp" type="text/html">
    <div class="layui-form" style="font-size:14px">
        <div class="layui-form-item">
             <div class="layui-inline seachitem">
                <label class="layui-form-label"  style="width: 30px;">����</label>
                <div class="layui-input-inline"  style="width: 80px;">        
                    <select name="c_regtype">
                        <option value=""></option>     
                        {{each cfg && cfg.regtypepair}}    
                        <option value="{{$index}}">{{$value}}</option>                           
                        {{/each}}                
                    </select>
                </div>
            </div> 
            <div class="layui-inline seachitem">
                <label class="layui-form-label"  style="width: 50px;">������</label>
                <div class="layui-input-inline"  style="width: 100px;">
                      <input type="text" name="c_org_m"  placeholder="��λ/����" autocomplete="off" class="layui-input">
                </div>
            </div>
           <div class="layui-inline seachitem">
                <label class="layui-form-label"  style="width:30px;">��Χ</label>
                <div class="layui-input-inline"  style="width: 80px;">            
                    <select name="reg_contact_type">
                        <option value=""></option>
                        {{each cfg && cfg.contacttype}}
                            <option value="{{$index}}">{{$value}}</option>
                        {{/each}}
                    </select>
                </div>
            </div>
            <div class="layui-inline seachitem">
                <label class="layui-form-label"  style="width: 30px;">����</label>
                <div class="layui-input-inline"  style="width: 100px;">
                      <input type="text" name="c_em"  placeholder="@" autocomplete="off" class="layui-input">
                </div>
            </div>             
             <div class="layui-inline seachitem">
                <label class="layui-form-label"  style="width: 30px;">״̬</label>
                 <div class="layui-input-inline"  style="width: 90px;">
                    <select name="c_status">
                        <option value="">����״̬</option>     
                        {{each cfg && cfg.statusinfo}} 
                            {{if $value.status_class=="contact_info"}}   
                            <option value="{{$value.status_id}}">{{$value.status_name}}</option>             
                            {{/if}}           
                        {{/each}}                
                    </select>
                </div>
                <div class="layui-input-inline"  style="width: 90px;">                
                    <select name="r_status">
                        <option value="">ʵ��״̬</option>     
                        {{each cfg && cfg.statusinfo}} 
                            {{if $value.status_class=="registant_id"}}   
                            <option value="{{$value.status_id}}">{{$value.status_name}}</option>             
                            {{/if}}           
                        {{/each}}                
                    </select>
                </div>               
            </div>          
            <div class="layui-inline seachitem">
                <label class="layui-form-label"  style="width: 30px;">ʱ��</label>
                <div class="layui-input-inline" style="width: 130px;">
                    <input type="text" name="c_date_begin" placeholder="��ʼʱ��" autocomplete="off" class="layui-input dropdate">
                </div>
                <div class="layui-form-mid">-</div>
                <div class="layui-input-inline" style="width: 130px;">
                    <input type="text" name="c_date_end" placeholder="����ʱ��" autocomplete="off" class="layui-input dropdate">
                </div>
            </div>
            <div class="layui-inline seachitem">
                <div class="layui-btn-group">
                    <button type="button" name="searchbtn" class="layui-btn layui-btn-normal" >����</button>
                    <button type="reset" class="layui-btn layui-btn-primary">����</button>
                </div>               
            </div>
        </div>
    </div>
</script>
<script id="tjbody_tmp" type="text/html">
    <div style="font-size:14px">
        {{if tjtype && tjtype=="mod"}}
        <div class="layui-form-item">
            <label class="layui-form-label">��ǰ״̬</label>  
            <div class="layui-form-mid layui-text">
                {{include 'statuslist_tmp' auditinfo}}   
            </div>       
        </div>   
        {{else if cfg && cfg.history && cfg.history.length>0}}     
        <div class="layui-form-item">
            <label class="layui-form-label">ʹ���������</label>    
            <div class="layui-input-block" style="width: 300px;">            
                <select name="history" lay-search lay-filter="history">  
                    <option></option>                   
                    {{each cfg.history}}      
                        <option value="{{$value.c_sysid}}" {{if auditinfo && auditinfo.c_sysid==$value.c_sysid}}selected{{/if}}>{{$value.c_org_m}}&nbsp;&nbsp;{{$value.c_em}}</option>
                    {{/each}}                   
                </select>
            </div> 
        </div>
        {{/if}}
        {{set checkregtype="I"}}    
        {{if eppidtype && eppidtype=="dom_id"}}
        <div class="layui-form-item">
            <label class="layui-form-label">����������</label>
             {{if tjtype && (tjtype=="mod" || tjtype=="domain")}}
             <div class="layui-form-mid layui-text" >
                {{set checkregtype=auditinfo.c_regtype}}
                {{cfg && auditinfo && cfg.regtypepair[auditinfo.c_regtype]}}
             </div>
            {{else}}
            <div class="layui-input-inline" style="width: 200px;">                     
                {{each cfg && cfg.regtypepair}}     
                    <input type="radio" name="c_regtype" lay-filter="c_regtype" value="{{$index}}" title="{{$value}}"                   
                    {{if ishasobj && ishasobj.isgovcn}}
                        {{checkregtype="E"}}
                        {{if $index=="E"}}
                            checked
                        {{else}}
                           disabled 
                        {{/if}}  
                    {{else if auditinfo}}
                        {{checkregtype=auditinfo.c_regtype}}
                        {{if $index==checkregtype}}
                            checked             
                        {{/if}}            
                    {{else if $index=="I"}}                       
                        checked
                    {{/if}} 
                    >
                {{/each}}                        
            </div>
                {{if ishasobj && ishasobj.isgovcn}}
                <div class="layui-form-mid layui-word-aux" ><i class="layui-icon">&#xe702;</i>&nbsp;����.gov.cn����,ֻ��ѡ����ҵ����</div>  
                {{/if}}
            {{/if}}
        </div>
       
        <div class="layui-form-item">
            <label class="layui-form-label"><i class="layui-icon">&#xe702;</i>&nbsp;��Ҫ����</label>
            <div class="layui-form-mid layui-word-aux" >�������������ƴ���������ӵ��Ȩ������д��������֤����ȫһ�µ���ҵ���ƻ�������<br>
            ���������豸������ȷ�����������������뱸����������һ�£����������ʵ����֤��</div>            
        </div>
       <div class="layui-form-item orgname"  {{if checkregtype=="I"}}style="display:none"{{/if}}>     
            <label class="layui-form-label">�����ߵ�λ����</label>
             {{if tjtype && (tjtype=="mod" || tjtype=="domain")}}
                <div class="layui-form-mid layui-text" >
                {{auditinfo && auditinfo.c_org_m }}
                </div>
                <div class="layui-form-mid layui-word-aux" >
                <i class="layui-icon">&#xe702;</i>&nbsp;�༭ʱ�������޸�������
               </div>
             {{else}}
            <div class="layui-input-block" style="width: 300px;">
                    <input type="text" name="c_org_m" lay-verify="c_org_m" placeholder="���ĵ�λ����" autocomplete="off" class="layui-input" value="{{auditinfo && auditinfo.c_org_m }}">
            </div>
            {{/if}}
        </div>
         {{/if}}
        <div class="layui-form-item">            
            <label class="layui-form-label">     
                <span  id="orgxmxx"> 
                {{if eppidtype && eppidtype=="dom_id"}}     
                    {{if checkregtype=="E"}}
                    ��ϵ������
                    {{else}}
                    ����������
                    {{/if}}   
                {{else}}
                    ��ϵ������
                {{/if}} 
                </span>         
             </label>
              {{if eppidtype && eppidtype=="dom_id" && auditinfo && tjtype && (tjtype=="mod"||tjtype=="domain")}}
              <div class="layui-form-mid layui-text" >
                {{if auditinfo.c_regtype=="E"}}
                    {{(auditinfo.c_ln_m+auditinfo.c_fn_m) }}
                {{else}}
                    {{auditinfo.c_org_m}}
                {{/if}}
              </div>
              <div class="layui-form-mid layui-word-aux" >
                <i class="layui-icon">&#xe702;</i>&nbsp;�༭ʱ�������޸�������
               </div>
              {{else}}
            <div class="layui-form-mid layui-text">��:</div>
            <div class="layui-input-inline" style="width: 100px;">
                <input type="text" name="c_ln_m" lay-verify="c_ln_m" placeholder="������" autocomplete="off" class="layui-input" value="{{auditinfo && auditinfo.c_ln_m}}">
            </div>
            <div class="layui-form-mid layui-text">��:</div>
            <div class="layui-input-inline" style="width: 140px;">
                <input type="text" name="c_fn_m" lay-verify="c_fn_m" placeholder="������" autocomplete="off" class="layui-input" value="{{auditinfo && auditinfo.c_fn_m}}">
            </div>
                {{/if}}
        </div>       
        <div class="layui-form-item">
            <label class="layui-form-label">��������</label>
            <div class="layui-input-inline" style="width: 100px;">
                <select name="c_co" lay-filter="c_co" lay-search lay-verify="required">
                    <option value="">����</option>           
                </select>           
            </div>  
            <div class="layui-input-inline" style="width: 120px;">
                <select name="c_st_m" lay-filter="c_st_m" lay-search lay-verify="required">
                    <option value="">ʡ</option>                   
                </select>
            </div>  
            <div class="layui-input-inline" style="width: 120px;">
                <select name="c_ct_m" lay-filter="c_ct_m"  lay-search lay-verify="required">
                    <option value="">��</option>                   
                </select>
            </div>
            {{if eppidtype && eppidtype=="dom_id"}}
            <div class="layui-input-inline" style="width: 120px;">
                <select name="c_dt_m" lay-filter="c_dt_m"  lay-search>
                    <option value="">��/��</option>                   
                </select>
            </div>     
            {{/if}}
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">ͨѶ��ַ</label>
            <div class="layui-input-block" style="width: 300px;">
                 <input type="text" name="c_adr_m" lay-verify="c_adr_m" placeholder="����" autocomplete="off" class="layui-input" value="{{auditinfo && auditinfo.c_adr_m}}">
            </div>
        </div> 
         <div class="layui-form-item">
            <label class="layui-form-label">�ʱ�</label>
            <div class="layui-input-block" style="width: 300px;">
                 <input type="text" name="c_pc" lay-verify="pcnumber" autocomplete="off" class="layui-input" value="{{auditinfo && auditinfo.c_pc}}">
            </div>
        </div> 
         <div class="layui-form-item">
            <label class="layui-form-label">��ϵ�绰</label>
            <div class="layui-input-inline" style="width: 70px;">
                <select name="c_ph_type" lay-filter="c_ph_type" lay-search>
                    <option value="0" {{if auditinfo && auditinfo.c_ph_type=="0" }}selected{{/if}}>�ֻ�</option>
                    <option value="1" {{if auditinfo && auditinfo.c_ph_type=="1"}}selected{{/if}}>�̻�</option>
                </select>
            </div>
            <div class="layui-form-mid layui-text" id="cocode"></div>
            <div class="layui-input-inline sjbox" style="width: 180px;">
                <input type="text" name="c_ph" lay-verify="phone" placeholder="�ֻ�����" autocomplete="off" class="layui-input" value="{{auditinfo && auditinfo.c_ph}}">
            </div> 
            <div class="layui-input-inline zjbox" style="width: 50px;display:none">
                <input type="text" name="c_ph_code" lay-verify="phoneqh" placeholder="����" autocomplete="off" class="layui-input" value="{{auditinfo && auditinfo.c_ph_code}}">
            </div>
            <div class="layui-form-mid layui-text zjbox"  style="display:none">-</div>
            <div class="layui-input-inline zjbox" style="width: 150px;display:none">
                <input type="text" name="c_ph_num" lay-verify="phonenum" placeholder="�̶��绰" autocomplete="off" class="layui-input" value="{{auditinfo && auditinfo.c_ph_num}}">
            </div>   
            <div class="layui-form-mid layui-text zjbox" style="display:none">-</div>
            <div class="layui-input-inline zjbox" style="width:50px;display:none">
              <input type="text" name="c_ph_fj" lay-verify="phonefj" placeholder="�ֻ�" autocomplete="off" class="layui-input" value="{{auditinfo && auditinfo.c_ph_fj}}">
            </div>                   
        </div> 
        <div class="layui-form-item">
            <label class="layui-form-label">��������</label>
            <div class="layui-input-block" style="width: 300px;">
                 <input type="text" name="c_em" lay-verify="email" placeholder="@" autocomplete="off" class="layui-input" value="{{auditinfo && auditinfo.c_em}}">
            </div>
        </div> 
        <!--������Ӣ��-->
       <hr style="margin:20px">
       {{if eppidtype && eppidtype=="dom_id"}} 
        <div class="layui-form-item">
            <label class="layui-form-label"><i class="layui-icon">&#xe702;</i>&nbsp;����</label>
            <div class="layui-form-mid layui-word-aux">������������������Ϣ��Ӣ��Ϊ׼���벻Ҫ��д���д��������Ӣ�����ƻ���������ֱ�ӽ����޸ġ�</div>
        </div>
        <div class="layui-form-item orgname" {{if checkregtype=="I"}}style="display:none"{{/if}}>
            <label class="layui-form-label">�����ߵ�λ��Ӣ�ģ�</label>
            {{if tjtype && (tjtype=="mod" || tjtype=="domain")}}
             <div class="layui-form-mid layui-text" >
                {{auditinfo && auditinfo.c_org }}
              </div>
               <div class="layui-form-mid layui-word-aux" >
                <i class="layui-icon">&#xe702;</i>&nbsp;�༭ʱ�������޸�������
               </div>
            {{else}}
            <div class="layui-input-block" style="width: 300px;">
                <input type="text" name="c_org" lay-verify="c_org" placeholder="Ӣ��" autocomplete="off" class="layui-input" value="{{auditinfo && auditinfo.c_org}}">
            </div>    
            {{/if}}       
        </div> 
        {{/if}}
        <div class="layui-form-item">
            <label class="layui-form-label">
                <span  id="orgxmxxen"> 
                {{if eppidtype && eppidtype=="dom_id"}}     
                    {{if checkregtype=="E"}}
                    ��ϵ������
                    {{else}}
                    ����������
                    {{/if}}   
                {{else}}
                    ��ϵ������
                {{/if}} 
                </span>��Ӣ�ģ�
            </label>
            {{if eppidtype && eppidtype=="dom_id" && auditinfo && tjtype && (tjtype=="mod" || tjtype=="domain")}}
              <div class="layui-form-mid layui-text" >
                 {{if auditinfo.c_regtype=="E"}}
                    {{auditinfo.c_ln}}&nbsp;{{auditinfo.c_fn}}
                {{else}}
                    {{auditinfo.c_org}}
                {{/if}}
              </div>
              <div class="layui-form-mid layui-word-aux" >
                <i class="layui-icon">&#xe702;</i>&nbsp;�༭ʱ�������޸�������
               </div>
            {{else}}
            <div class="layui-form-mid layui-text">��:</div>
            <div class="layui-input-inline" style="width: 100px;">
                <input type="text" name="c_ln" lay-verify="c_ln" placeholder="Ӣ����" autocomplete="off" class="layui-input" value="{{auditinfo && auditinfo.c_ln}}">
            </div>
            <div class="layui-form-mid layui-text">��:</div>
            <div class="layui-input-inline" style="width: 140px;">
                <input type="text" name="c_fn" lay-verify="c_fn" placeholder="Ӣ����" autocomplete="off" class="layui-input" value="{{auditinfo && auditinfo.c_fn}}">
            </div>
            {{/if}}
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">ʡ�ݣ�Ӣ�ģ�</label>
            <div class="layui-input-block" style="width: 300px;">
                <input type="text" name="c_st" lay-verify="c_st" placeholder="Ӣ��" autocomplete="off" class="layui-input" value="{{auditinfo && auditinfo.c_st}}">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">���У�Ӣ�ģ�</label>
            <div class="layui-input-block" style="width: 300px;">
                <input type="text" name="c_ct" lay-verify="c_ct" placeholder="Ӣ��" autocomplete="off" class="layui-input" value="{{auditinfo && auditinfo.c_ct}}">
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">ͨѶ��ַ��Ӣ�ģ�</label>
            <div class="layui-input-block" style="width: 300px;">
                <input type="text" name="c_adr" lay-verify="c_adr" placeholder="Ӣ��" autocomplete="off" class="layui-input" value="{{auditinfo && auditinfo.c_adr}}">
            </div>
        </div>
        {{if tjtype && tjtype=="domain"}}
            {{if auditinfo && auditinfo.reg_contact_type && auditinfo.reg_contact_type.indexOf("hk")>=0}}
            {{include 'zjxxhk_tmp'}}        
         
            {{/if}}
         
        {{else}}
        <hr style="margin:10px">
        <div class="layui-form-item" style="margin:0">
            <label class="layui-form-label"><i class="layui-icon">&#xe702;</i></label>
            <div class="layui-form-mid layui-word-aux">            
            ����.hk�Ͳ�������������.��˾/.����/.��ɽ/.�㶫�������⣬����ע����������뵥����ѡ.
             </div>
        </div>        
        <div class="layui-form-item">
            <label class="layui-form-label">���÷�Χ</label>
            <div class="layui-input-block" >
               {{each cfg && cfg.contacttype}} 
                {{if $index!="govcn"}} 
                <input type="checkbox" value="{{$index}}"  lay-filter="reg_contact_type"  name="reg_contact_type" title="{{$value}}" 
                    {{if $index=="cg"}}
                        checked disabled
                    {{else}}
                        {{if auditinfo && auditinfo.reg_contact_type && auditinfo.reg_contact_type.indexOf($index)>=0}}checked {{/if}}               
                        {{if tjtype && tjtype=="mod" }}
                            {{if $index=="gswl"}}
                            disabled
                            {{else if auditinfo && auditinfo.reg_contact_type.indexOf($index)>=0}}
                            disabled
                            {{/if}}
                        {{/if}}
                    {{/if}}
                >      
                {{/if}}        
               {{/each}}                 
            </div>           
        </div>
        <div class="showbox" id="zjxxhkbox" style="display:none">
        {{include 'zjxxhk_tmp'}}          
        </div>
        <div class="showbox" id="zjxxgswlbox" style="display:none">
        {{include 'zjxxgswl_tmp'}}
        </div>   
        {{/if}} 
        {{if tjtype && (tjtype=="add" || tjtype=="mod")}}   
            <hr style="margin:20px">
            <div class="layui-form-item" >
                <div class="layui-input-block">   
                <button name="auditsubbtn" class="layui-btn  layui-btn-lg layui-btn-normal" lay-submit lay-filter="auditsubbtn">��������</button>  
                <button type="button" name="resetbtn" class="layui-btn  layui-btn-lg layui-btn-primary">����</button>
                </div>
            </div>
        {{/if}}
        {{if tjtype && tjtype=="domain"}} 
            <hr style="margin:20px">
            <div class="layui-form-item" >
                <div class="layui-input-block">   
                <button name="domainmodisubbtn" class="layui-btn  layui-btn-lg layui-btn-normal" lay-submit lay-filter="domainmodisubbtn">��������</button>  
                <button type="button" name="resetbtn" class="layui-btn  layui-btn-lg layui-btn-primary">����</button>
                </div>
            </div>
        {{/if}}
    </div>
</script>
<script id="zjxxhkidtype_tmp" type="text/html">
    <select name="c_idtype_hk" lay-filter="c_idtype_hk"  lay-verify="idtype"> 
    <option></option>   
    {{if auditinfo && auditinfo.c_regtype=="I"}}
            <option value="OTHID" {{if auditinfo && auditinfo.c_idtype_hk=="OTHID"}}selected{{/if}}>��½���֤</option>
            <option value="HKID" {{if auditinfo && auditinfo.c_idtype_hk=="HKID"}}selected{{/if}}>������֤</option>
            <option value="PASSNO" {{if auditinfo && auditinfo.c_idtype_hk=="PASSNO"}}selected{{/if}}>���պ���</option>
            <option value="BIRTHCERT" {{if auditinfo && auditinfo.c_idtype_hk=="BIRTHCERT"}}selected{{/if}}>����֤��</option>
    {{else}}         
            <option value="ORG" {{if auditinfo && auditinfo.c_idtype_hk=="ORG"}}selected{{/if}}>��֯��������֤</option>       
            <option value="CI" {{if auditinfo && auditinfo.c_idtype_hk=="CI"}}selected{{/if}}>Ӫҵִ��</option>
            <option value="BR" {{if auditinfo && auditinfo.c_idtype_hk=="BR"}}selected{{/if}}>��۹�˾�Ǽ�֤</option>         
    {{/if}}
    </select> 
</script>
<script id="zjxxhk_tmp" type="text/html">
    <div class="layui-form-item" >
        <label class="layui-form-label">.hk����֤��</label>
        <div class="layui-input-inline" id="hkidtype_box" style="width: 100px;">      
            {{include 'zjxxhkidtype_tmp'}}
            
        </div>
        <div class="layui-input-inline" style="width: 200px;">
            <input type="text" name="c_idnum_hk" lay-verify="idnum" placeholder="֤������" autocomplete="off" class="layui-input" value="{{auditinfo && auditinfo.c_idnum_hk}}">
        </div>
    </div>
</script>
<script id="zjxxgswl_tmp" type="text/html">
    <div class="layui-form-item" >
        <label class="layui-form-label">������������֤��</label>
        {{if tjtype && tjtype=="mod"}}
        <div class="layui-form-mid layui-text">
            {{if auditinfo && auditinfo.c_idtype_gswl=="SFZ"}}
            ��½���֤
            {{else}}
            ��֯��������֤
            {{/if}}
            
            {{auditinfo && auditinfo.c_idnum_gswl}}
        </div>
        {{else}}
        <div class="layui-input-inline" style="width: 100px;">            
            <select name="c_idtype_gswl" lay-filter="c_idtype_gswl"  lay-verify="idtype" > 
                 <option></option>     
                <option value="SFZ" {{if  auditinfo && auditinfo.c_idtype_gswl=="SFZ"}}selected{{/if}}>��½���֤</option>   
                <option value="ORG" {{if  auditinfo && auditinfo.c_idtype_gswl=="ORG"}}selected{{/if}}>��֯��������֤</option> 
            </select>                
        </div>
        <div class="layui-input-inline" style="width: 200px;">
            <input type="text" name="c_idnum_gswl" lay-verify="idnum" placeholder="֤������" autocomplete="off" class="layui-input" value="{{auditinfo && auditinfo.c_idnum_gswl}}">
        </div>
        <div class="layui-form-mid layui-word-aux">            
            <i class="layui-icon">&#xe702;</i>&nbsp;����Ϣ��Ӱ�������������������ȷ��д��ȷ����ʵ��Ч��
        </div>
        {{/if}}
    </div>
</script>
<script id="statuslist_tmp" type="text/html">
    <button type="button" data-sysid="{{c_sysid}}" name="auditfilebtn"  
    {{if failinfo && failinfo!=""}}data-hovermsg="{{failinfo}}"{{/if}}
    class="layui-btn  layui-btn-xs 
    {{if c_status=="0"}}
    layui-btn-normal
    {{else if c_status=="1"}}
     layui-btn-green
    {{else if c_status=="3" || c_status=="4"}}
    layui-btn-danger
    {{else}}
    layui-bg-gray
    {{/if}}
    ">{{status_name}}</button>
</script>
<script id="statusbtnlist_tmp" type="text/html">   
    {{if c_status && c_statusname}}
        <button type="button" 
        {{if c_sysid}}
        data-sysid="{{c_sysid}}" name="auditfilebtn"  class="layui-btn
        {{else if d_id}}
        data-sysid="{{d_id}}" name="auditdoaminbtn"  class="layui-btn
        {{/if}}
          layui-btn-xs 
        {{if c_status=="0"}}
        layui-btn-normal
        {{else if c_status=="1"}}
        layui-btn-green
        {{else if c_status=="3" || c_status=="4"}}
        layui-btn-danger
        {{else}}
        layui-bg-gray
        {{/if}}
        ">{{c_statusname}}</button>
    {{/if}}
    {{if r_status && r_statusname}}
        <button type="button" 
        {{if c_sysid}}
        data-sysid="{{c_sysid}}" name="auditstatusbtn"  class="layui-btn
        {{else if d_id}}
        data-sysid="{{d_id}}" name="auditdoaminbtn"  class="layui-btn
        {{/if}}        
          layui-btn-xs     
        {{if r_status=="4" || r_status=="3"}}
        layui-btn-danger
        {{else if r_status=="1"}}
        layui-btn-green
        {{else if r_status=="0"}}
        layui-btn-normal
        {{else}}
        layui-bg-gray
        {{/if}}">{{r_statusname}}</button> 
    {{else}}   
        <span class="layui-badge layui-bg-gray">����ʵ��</span>
    {{/if}}
</script>
<script id="statuslistr_tmp" type="text/html">
   {{each cfg && cfg.statusinfo}}
        {{if $value.status_class=="registant_id"}}      
            {{if r_status && $value.status_id==r_status}}
                <button type="button" data-sysid="{{c_sysid}}" name="auditstatusbtn"  
                {{if r_failinfo && r_failinfo!=""}}data-hovermsg="{{r_failinfo}}"{{/if}}
                class="layui-btn  layui-btn-xs 
                {{if $value.status_id=="4" || $value.status_id=="3"}}
                layui-btn-danger
                {{else if $value.status_id=="1"}}
                layui-btn-green
                {{else if $value.status_id=="0"}}
                layui-btn-normal
                {{else}}
                layui-bg-gray
                {{/if}}">{{$value.status_name}}</button>          
            {{/if}}
        {{/if}}
   {{/each}}
</script>
<script id="domainstatuslist_tmp" type="text/html">
    {{each $data}}        
        <span class="layui-badge {{if $value.indexOf("�ɹ�")>=0 || $value.indexOf("�ѹ���")>=0}}layui-bg-green{{else if $value.indexOf("�ܾ�")>=0}}layui-btn-danger{{else if $value.indexOf("����")>=0}}layui-bg-gray{{else}}layui-bg-blue{{/if}}">{{$index}}��{{$value}}</span>        
    {{/each}}
</script>
<script id="regcontacttype_tmp" type="text/html">
    {{each cfg && cfg.contacttype}}    
        {{if reg_contact_type.indexOf($index)>=0}}   
        <span class="layui-badge {{if $index=="cg"}} layui-bg-gray{{else}}layui-bg-orange{{/if}}">{{$value}}</span>  
        {{/if}}     
    {{/each}}
</script>

<script id="auditbox_tmp" type="text/html">
    <div class="layui-tab layui-tab-brief" style="font-size:14px" lay-filter="">
    <ul id="auditboxtab" class="layui-tab-title" >
        <li data-tmp="file" {{if tab=="file"}} class="layui-this" {{/if}}>ʵ������</li>
        <li data-tmp="ymsqb" style="display:none" {{if tab=="ymsqb"}} class="layui-this" {{/if}}>���������</li>        
        <li data-tmp="status" {{if tab=="status"}} class="layui-this" {{/if}}>״̬����</li>    
    </ul>
    <form name="auditbox_form"  class="layui-form">
    <div style="text-align:center">
    <i class="layui-icon layui-icon-loading" ></i>  
    </div>
    </form>
    </div> 
</script>
<script id="auditstatusbox_tmp" type="text/html">     
    <div id="auditstatussearchbox" style="margin-top:10px"></div>
    <div id="auditstatusinfobox" style="margin:0;"></div>
</script>
<script id="auditstatussearch_tmp" type="text/html">
    <div class="layui-form" style="margin:0;padding:0">
        <div class="layui-form-item">
            <div class="layui-inline seachitem">
                <label class="layui-form-label"  style="width:30px;">ID</label>
                <div class="layui-input-inline"  style="width: 150px;">
                    <input type="text" name="registrantid"  placeholder="ע��ID" autocomplete="off" class="layui-input">
                </div>
            </div>                    
            <div class="layui-inline seachitem">
                <label class="layui-form-label"  style="width: 70px;">ʵ��״̬</label>
                <div class="layui-input-inline"  style="width: 80px;">                
                    <select name="r_status">
                        <option value=""></option>     
                        {{each cfg && cfg.statusinfo}} 
                            {{if $value.status_class=="registant_id"}}   
                            <option value="{{$value.status_id}}">{{$value.status_name}}</option>              
                            {{/if}}           
                        {{/each}}                
                    </select>
                </div>
            </div>  
            <div class="layui-inline seachitem">
                <div class="layui-input-inline"  style="width: 200px;">
                    <button type="button" name="searchbtn" class="layui-btn layui-btn-normal" >����</button>
                    <button type="reset" name="ghztresetbtn" class="layui-btn layui-btn-primary">����</button>
                </div>                
            </div>   
        </div>    
    </div>
</script>
<script id="auditstatusinfo_tmp" type="text/html">
    {{if data.info.length>0}}
        <table lay-filter="auditstatustable">
            <thead>
            <tr >      
                <th lay-data="{field:'r_sysid',width:200,sort: true}">ע��ID</th>
                <th lay-data="{field:'r_status',width:120,sort: true}">ʵ��״̬</th>                
                <th lay-data="{field:'auditclass',width:100,sort: true}">ʵ���ӿ�</th>  <th lay-data="{field:'r_date',width:190,sort: true}">����ʱ��</th>            
            </tr> 
            </thead>
            <tbody>    
            {{each data.info}}
            <tr>
                <td>
                {{if $value.thisdomain && $value.thisdomain!=""}}
                <b title="��ǰ����ʹ�õ�id">{{$value.registrantid}} </b>
                <span class="layui-badge-dot" title="��ǰ����ʹ�õ�id"></span>
                {{else}}
                {{$value.registrantid}} 
                {{/if}}             
                </td>
                <td> 
                    {{if $value.auditclass!=""}}
                     
                    {{set t=$value;t.cfg=$data.cfg}}
                    {{include 'statuslistr_tmp' t}}
                    {{else}}
                    <span class="layui-badge layui-bg-gray">����ʵ��</span>
                    {{/if}}
                </td>                    
                <td>{{if $value.auditclass!=""}}{{$value.auditclass}}{{else}}--{{/if}}</td> 
                <td>{{$value.r_date}}</td>               
            </tr>  
            {{/each}}     
            </tbody>
        </table>
        <div style="margin:0 0 0 10px" id="pagebox_mg"></div>       
    {{else}}
        <div class="msg-box warn-msg-box">
            <i class="msg-icon"></i>���κμ�¼
        </div>    
    {{/if}}  
</script>
<script id="auditfilebox_tmp" type="text/html"> 
        {{set isallowmod=0}}
        {{if auditinfo && ("0,3,4".indexOf(auditinfo.c_status)>=0 || "3".indexOf(auditinfo.r_status)>=0)}}
            {{set isallowmod=1}}
        {{/if}}
        {{if auditinfo && auditinfo.domaininfo && auditinfo.domaininfo.strdomain}}
        <div class="layui-form-item" style="margin-bottom:0">
            <label class="layui-form-label">������</label>
            <div class="layui-form-mid layui-text" style="width:400px">
            {{if auditinfo.domaininfo.strdomain.indexOf("xn--")>=0}}
                {{auditinfo.domaininfo.s_memo}}
            {{else}}
                {{auditinfo.domaininfo.strdomain}}
            {{/if}}
            </div>
        </div>  
        {{/if}}
        <div class="layui-form-item" style="margin-bottom:0;margin-top:0">
            <label class="layui-form-label">����״̬��</label>
            <div class="layui-form-mid layui-text" style="width:450px">
                {{set t=auditinfo;t.cfg=$data.cfg}}
                {{if auditinfo.c_status=="3"}}   
                     <div style="color:#FF5722">   
                    {{include 'statuslist_tmp' auditinfo}}{{include 'statuslistr_tmp' t}}
                    &nbsp;<i class="layui-icon layui-icon-tips" style="font-size: 16px; "></i>&nbsp;�ܾ�ԭ��
                    {{@auditinfo.failinfo}}</div>
                {{else if auditinfo.r_status=="3"}}   
                     <div style="color:#FF5722">   
                    {{include 'statuslist_tmp' auditinfo}}{{include 'statuslistr_tmp' t}}
                    &nbsp;<i class="layui-icon layui-icon-tips" style="font-size: 16px; "></i>&nbsp;�ܾ�ԭ��
                    {{@auditinfo.r_failinfo}}</div>
                {{else}}
                   <div class="layui-btn-group">{{include 'statuslist_tmp' auditinfo}}{{include 'statuslistr_tmp' t}} </div>
                {{/if}}  
            </div>
        </div>  
         {{if auditinfo && auditinfo.domaininfo && auditinfo.domainstatus}}
        <div class="layui-form-item" style="margin-top:0">
            <label class="layui-form-label">����״̬��</label>
            <div class="layui-form-mid layui-text" style="width:450px">
               
                    {{if auditinfo.domaininfo.r_status=="3"}}  
                        <div style="color:#FF5722">                
                        {{include 'domainstatuslist_tmp' auditinfo.domainstatus}}
                        &nbsp;<i class="layui-icon layui-icon-tips" style="font-size: 16px; "></i>&nbsp;�ܾ�ԭ��
                        {{@auditinfo.domaininfo.r_failinfo}}    
                        </div>
                    {{else}}                    
                      <div class="layui-btn-group">{{include 'domainstatuslist_tmp' auditinfo.domainstatus}}</div>        
                    {{/if}}
               
            </div>
        </div>  
         {{/if}} 
        <div class="layui-form-item">
            <label class="layui-form-label">{{if auditinfo && auditinfo.c_regtype=="E"}}���������ߵ�λ{{else}}����������{{/if}}��</label>
            <div class="layui-form-mid layui-text" style="width:450px">
            ��{{auditinfo && auditinfo.regtypename}}��
            {{auditinfo && auditinfo.c_org_m}}
            {{if auditinfo && auditinfo.domaininfo && auditinfo.ismyact && auditinfo.ismyact=="False"}}
                <a href="/manager/domain/contactinfo/?tab=gh&ghdomain={{auditinfo.domaininfo.strdomain}}" title="�޸�"><i class="layui-icon layui-icon-edit" style="color:#1E9FFF"></i></a>
            {{/if}}
            </div>
        </div>
        <div  class="layui-form-item">
            <label class="layui-form-label">{{if auditinfo && auditinfo.c_regtype=="E"}}�����ߵ�λ֤��{{else}}������֤��{{/if}}���룺</label>
            {{if isallowmod==0}}
                <div class="layui-form-mid layui-text" style="width:450px">
                {{each cfg && cfg.zjlxpair}}
                    {{if auditinfo.orgfile && auditinfo.orgfile.f_type==$value.t_sysid}}
                        {{$value.t_name}}
                    {{/if}}  
                {{/each}}        
    
                {{auditinfo.orgfile && auditinfo.orgfile.f_code}}
                </div>
            {{else}}
                <div class="layui-input-inline" style="width: 100px;"> 
                    <select name="f_type_org" lay-filter="f_type_org"  lay-search lay-verify="idtype"> 
                        <option></option>    
                        {{each cfg && cfg.zjlxpair}}
                            {{if $value.t_type==auditinfo.c_regtype}}
                                {{if !(auditinfo && auditinfo.c_org_m && (auditinfo.c_org_m.indexOf("��˾")>=0 || auditinfo.c_org_m.indexOf("������")>=0) && auditinfo.c_regtype=="E" && ($value.t_sysid==4 || $value.t_sysid==2))}}
                                <option value="{{$value.t_sysid}}" {{if  auditinfo && auditinfo.orgfile && auditinfo.orgfile.f_type==$value.t_sysid}}selected{{/if}}>{{$value.t_name}}</option> 
                                {{/if}}
                            {{/if}}  
                        {{/each}}
                    </select>                
                </div>
                <div class="layui-input-inline" style="width: 200px;">
                    <input type="text" name="f_code_org" lay-verify="idnum" placeholder="֤������" autocomplete="off" class="layui-input" value="{{auditinfo && auditinfo.orgfile && auditinfo.orgfile.f_code}}">
                </div>
            {{/if}}
        </div>   
        <div class="layui-form-item">
            <label class="layui-form-label">{{if auditinfo && auditinfo.c_regtype=="E"}}�����ߵ�λ֤������{{else}}������֤������{{/if}}��</label>
            {{if isallowmod==0}}
                <div class="layui-input-block"> 
                    <div class="layui-upload-drag"  style="width: 100px; height:100px; padding:0;" id="nobtn_org">  
                    </div>
                </div>
             {{else}}
                <div class="layui-input-block"> 
                    <div class="layui-upload-drag"  style="width: 100px; height:100px; padding:0;" id="upbtn_org"  lay-verify="uploadfile">   
                        
                            <i class="layui-icon layui-icon-upload" style="font-size: 40px;line-height:1.6 "></i> 
                    <div>����ϴ�</div>  
                    
                    </div>
                </div> 
            {{/if}}      
        </div> 
    {{if auditinfo && auditinfo.c_regtype=="E"}}
        <div class="layui-form-item">
            <label class="layui-form-label">ʵ����Χ��</label>
            <div class="layui-input-block" >
            <input type="checkbox" value=""  lay-filter="reg_contact_type_file"  name="reg_contact_type_file" title="��������" checked disabled>             
            <input type="checkbox" value="govcn"  lay-filter="reg_contact_type_file"  name="reg_contact_type_file" title=".gov.cn��������" 
            {{if auditinfo && (auditinfo.reg_contact_type.indexOf("govcn")>=0 || auditinfo.domaininfo && auditinfo.domaininfo.proid=="domgovcn")}}checked{{/if}}
            {{if isallowmod==0}}
                disabled
            {{else if auditinfo && auditinfo.domaininfo &&  auditinfo.domaininfo.proid=="domgovcn"}} 
                disabled 
            {{/if}}
            > 
            </div>           
        </div>
        <hr>
        <div class="layui-form-item">              
            <div class="layui-form-mid layui-word-aux" style="font-size:14px; margin:0 20px;color:#666;"><i class="layui-icon" style="font-size: 16px; color: #1E9FFF;">&#xe702;</i>&nbsp;.gov.cn �������ҹ�����������վ��ר������,ֻ���������ص�λ�ſ���ע�ᣬ���ṩ������ϵ�����֤��ӡ����</div>
        </div>
        <!--��ϵ��-->
        <div class="showbox" id="zjxxgovcnbox" style="display:none">                
            <div class="layui-form-item">
                <label class="layui-form-label">������ϵ�ˣ�</label>
                <div class="layui-form-mid layui-text" style="width:450px">
                {{auditinfo && (auditinfo.c_ln_m + auditinfo.c_fn_m)}}
                
                {{if auditinfo && auditinfo.domaininfo && auditinfo.ismyact && auditinfo.ismyact=="False"}}
                    <a href="/manager/domain/contactinfo/?tab=gh&ghdomain={{auditinfo.domaininfo.strdomain}}" title="�޸�"><i class="layui-icon layui-icon-edit" style="color:#1E9FFF"></i></a>
                {{/if}}
                </div>
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">��ϵ��֤�����룺</label>
                {{if isallowmod==0}}
                   <div class="layui-form-mid layui-text" style="width:450px">
                    {{each cfg && cfg.zjlxpair}}
                       {{if auditinfo.lxrfile && auditinfo.lxrfile.f_type==$value.t_sysid}}
                            {{$value.t_name}}
                       {{/if}}  
                    {{/each}}     
        
                   {{auditinfo.lxrfile && auditinfo.lxrfile.f_code}}
                    </div>
                {{else}}
                    <div class="layui-input-inline" id="govcnidtype_box" style="width: 100px;"> 
                        <select name="f_type_lxr"  lay-filter="f_type_lxr" lay-search lay-verify="idtype"> 
                            <option></option>    
                            {{each cfg && cfg.zjlxpair}}
                                {{if $value.t_type=="I"}}
                                <option value="{{$value.t_sysid}}" {{if  auditinfo && auditinfo.lxrfile && auditinfo.lxrfile.f_type==$value.t_sysid}}selected{{/if}}>{{$value.t_name}}</option> 
                                {{/if}}  
                            {{/each}}                       
                    
                        </select>     
                    </div>
                    <div class="layui-input-inline" style="width: 200px;">
                        <input type="text" name="f_code_lxr" lay-verify="idnum" placeholder="֤������" autocomplete="off" class="layui-input" value="{{auditinfo && auditinfo.lxrfile && auditinfo.lxrfile.f_code}}">
                    </div>
                {{/if}}
            </div>
            <div class="layui-form-item">
                <label class="layui-form-label">��ϵ��֤�����ϣ�</label>
                {{if isallowmod==0}}
                    <div class="layui-input-block" >                    
                        <div class="layui-upload-drag" style="width: 100px; height:100px; padding:0;" id="nobtn_lxr">  
                         </div>
                    </div>   
                {{else}}
                    <div class="layui-input-block">                     
                        <div class="layui-upload-drag" style="width: 100px; height:100px; padding:0;" id="upbtn_lxr" lay-verify="uploadfile">  
                    
                            <i class="layui-icon layui-icon-upload" style="font-size: 40px;line-height:1.6"></i> 
                        <div>����ϴ�</div>  
                    
                        </div>
                    </div>   
                {{/if}}    
            </div>
        </div>     
    {{/if}}
    {{if isallowmod==1}}
    <hr>
        <div class="layui-form-item" style="margin:10px 0 0 0" >
             <label class="layui-form-label"></label>
            <div class="layui-input-block">   
                <button name="auditfilesubbtn" style="width:150px" class="layui-btn layui-btn-normal" lay-submit lay-filter="auditfilesubbtn">�����ύ</button>  
                <button type="button" name="auditfileresetbtn" class="layui-btn layui-btn-primary">����</button>  
            </div>
        </div>
    {{/if}}
</script>
<script id="ymsqbbox_tmp" type="text/html"> 
        <div class="layui-form-item">
            <label class="layui-form-label">����״̬��</label>
            <div class="layui-form-mid layui-text">
                {{if auditinfo && auditinfo.domaininfo && auditinfo.domainstatus}}
                    {{if auditinfo.domaininfo.r_status=="3"}}                  
                        {{include 'domainstatuslist_tmp' auditinfo.domainstatus}}
                        &nbsp;<i class="layui-icon layui-icon-tips" style="font-size: 16px; "></i>&nbsp;�ܾ�ԭ��
                        {{@auditinfo.domaininfo.r_failinfo}}    
                    {{else}}                    
                      {{include 'domainstatuslist_tmp' auditinfo.domainstatus}}        
                    {{/if}}
                {{/if}} 
            </div>
        </div>           
        <div class="layui-form-item">
            <label class="layui-form-label">������</label>
            <div class="layui-form-mid layui-text">
            {{auditinfo && auditinfo.domaininfo && auditinfo.domaininfo.strdomain}}
            </div>
        </div>   
        <div class="layui-form-item">
            <label class="layui-form-label">�����ߣ�</label>
            <div class="layui-form-mid layui-text">
            {{auditinfo && auditinfo.c_org_m}}
            {{if auditinfo && auditinfo.domaininfo}}
                <a href="/manager/domain/contactinfo/?tab=gh&ghdomain={{auditinfo.domaininfo.strdomain}}" title="�޸�"><i class="layui-icon layui-icon-edit" style="color:#1E9FFF"></i></a>
            {{/if}}
            </div>
        </div>     
        <div class="layui-form-item">
            <label class="layui-form-label">��ϵ�ˣ�</label>
            <div class="layui-form-mid layui-text">
            {{if auditinfo}}
                {{auditinfo.c_ln_m}}{{auditinfo.c_fn_m}}
            {{/if}}
            {{if auditinfo && auditinfo.domaininfo}}
                <a href="/Manager/domain/contactinfo/domainmodi.asp?domainid={{auditinfo.domaininfo.d_id}}" title="�޸�"><i class="layui-icon layui-icon-edit" style="color:#1E9FFF"></i></a>
            {{/if}}
            </div>
        </div>
       
        <div class="layui-form-item">
            <label class="layui-form-label">��ϵ�绰��</label>
            <div class="layui-form-mid layui-text">
            {{auditinfo && auditinfo.c_ph_all}}
            {{if auditinfo && auditinfo.domaininfo}}
                <a href="/Manager/domain/contactinfo/domainmodi.asp?domainid={{auditinfo.domaininfo.d_id}}" title="�޸�"><i class="layui-icon layui-icon-edit" style="color:#1E9FFF"></i></a>
            {{/if}}
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">������ID��</label>
            <div class="layui-form-mid layui-text">
            {{auditinfo && auditinfo.domaininfo && auditinfo.domaininfo.registrantid}}
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">���������</label>
            {{if auditinfo && auditinfo.domaininfo && (auditinfo.domaininfo.ymsqb_state=="1" || auditinfo.domaininfo.ymsqb_state=="3")}}
                <div class="layui-input-block"> 
                    <div class="layui-upload-drag"  style="width: 100px; height:100px; padding:0;" id="seebtn_ymsqb">  
                    </div>
                </div>
             {{else}}
                <div class="layui-input-block"> 
                    <div class="layui-upload-drag"  style="width: 100px; height:100px; padding:0;" id="upbtn_ymsqb"  lay-verify="uploadfile">                        
                            <i class="layui-icon layui-icon-upload" style="font-size: 40px;line-height:1.6 "></i> 
                    <div>����ϴ�</div>                    
                    </div>
                </div> 
            {{/if}}      
        </div> 
         <div class="layui-form-item">              
            <div class="layui-form-mid layui-word-aux" style="font-size:14px; margin:0 20px;color:#666;"><i class="layui-icon" style="font-size: 16px; color: #1E9FFF;">&#xe702;</i>&nbsp;ע��gov.cn������Ҫ�ṩ���������ɨ�������<a href="http://www.west.cn/CustomerCenter/gov����ע�������.doc" target="_blank" style="color:#06c">����"����ע�������"</a><a href="http://www.west.cn/CustomerCenter/gov����ע�������ʾ����.doc" target="_blank" style="color:#06c">��ʾ����</a>����ʾ����д�ú�Ӹǵ�λ���£�ɨ����ڴ��ϴ���</div>
        </div> 
     {{if !(auditinfo && auditinfo.domaininfo && (auditinfo.domaininfo.ymsqb_state=="1" || auditinfo.domaininfo.ymsqb_state=="3"))}}
    <hr>
        <div class="layui-form-item" style="margin:10px 0 0 0" >
             <label class="layui-form-label"></label>
            <div class="layui-input-block">   
                <button name="auditymsqbsubbtn" style="width:150px" class="layui-btn layui-btn-normal" lay-submit lay-filter="auditymsqbsubbtn">�����ύ</button>
            </div>
        </div>
    {{/if}}
</script>
<script id="domainlbsearch_tmp" type="text/html">
    <div class="layui-form">
        <div class="layui-form-item">
            <div class="layui-inline seachitem" >
                <label class="layui-form-label"  style="width:40px;padding:9px 5px">����</label>
                <div class="layui-input-inline"  style="width: 150px;">
                      <input type="text" name="strdomain"   autocomplete="off" placeholder="�����ؼ���" class="layui-input">
                </div>
            </div>                   
            <div class="layui-inline seachitem">
                <label class="layui-form-label"  style="width:auto;padding:9px 5px">ʵ��״̬</label>
                <div class="layui-input-inline"  style="width: 100px;">                  
                    <select name="r_status">
                        <option value=""></option>   
                        {{each cfg.statusinfo v k}}
                           {{if v.status_class=="registant_id"}}
                             <option value="{{v.status_id}}">{{v.status_name}}</option>        {{/if}}
                        {{/each}}
                    </select>
                </div>
            </div>          
            <div class="layui-inline seachitem">
                <div class="layui-btn-group"  style="width:audit;margin:0">
                <button type="button" name="domainsearchbtn" class="layui-btn layui-btn-normal" >����</button>
                <button type="reset" class="layui-btn layui-btn-primary">����</button>
                <button type="button" name="exportdomain" class="layui-btn layui-btn-primary">
                    ����
                    <i class="layui-icon layui-icon-export"></i>
                </button>
                </div>               
            </div>
        </div>
    </div>
</script>
<script id="domainlb_tmp" type="text/html">
   {{if data.info.length>0}}
    <table lay-filter="domainlb">
        <thead>
        <tr>
            <th lay-data="{field:'strdomain', width:240}">����</th>
            <th lay-data="{field:'eppid', width:180}">ע��ID</th>
            <th lay-data="{field:'auditclass', width:100}">ʵ���ӿ�</th>    
            <th lay-data="{field:'r_sysid', width:150}">ʵ��״̬</th>    
        </tr> 
        </thead>
        <tbody>    
        {{each data.info}}
        <tr>
            <td>
            {{if $value.strdomain.indexOf("xn--")>=0}}
                 {{$value.s_memo}}
            {{else}}
                {{$value.strdomain}}
            {{/if}}</td>
            <td>  
            {{$value.registrantid}}
            </td>
            <td>{{if $value.auditclass!=""}}{{$value.auditclass}}{{else}}--{{/if}}</td> 
            <td>
             {{if $value.auditclass!=""}}                     
                    {{set t=$value;t.cfg=$data.cfg}}
                    {{include 'statuslistr_tmp' t}}
             {{else}}
                    <span class="layui-badge layui-bg-gray">����ʵ��</span>
             {{/if}}           
            </td>       
        </tr>  
        {{/each}}     
        </tbody>
    </table>
    <div id="domainpagebox_mg" style="margin:0 5px;"></div>
   {{else}}
    <div class="msg-box warn-msg-box">
        <i class="msg-icon"></i>���κμ�¼
    </div>    
   {{/if}}  
</script>
<script id="domainlistbox_tmp" type="text/html">
    <form name="auditdomainlb_form"  class="layui-form" data-id="{{c_sysid}}">
        <div id="domainsearchbox" style="margin-top:10px"></div>
        <div id="domaininfobox" style="margin:0"></div>
    </form>
</script>
<script id="ghbody_tmp" type="text/html">
    <div style="font-size:14px">
        <div class="layui-form-item">
            <label class="layui-form-label">�����б� </label>
            <div class="layui-input-inline" style="width: 400px;">           
              <textarea name="ghdomain" placeholder="��ÿ������һ������" class="layui-textarea">{{ghdomain}}</textarea>         
            </div>
            <div class="layui-input-inline" style="width: 120px;">           
               <button type="button" name="domsearchbtn" class="layui-btn  layui-btn-lg layui-btn-normal" lay-filter="domsearchbtn">ѡ������</button>          
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">ѡ���޸Ķ��� </label>
            <div class="layui-input-block">  
                {{each cfg && cfg.eppidtype}} 
                 <input type="checkbox"  name="eppidtype"  value="{{$index}}" title="{{$value}}" checked>  
                {{/each}} 
            </div>
        </div>
        <div class="layui-form-item">
            <label class="layui-form-label">ѡ������ </label>
            <div class="layui-input-block" style="width:1100px" id="ghlbminbox"> 
               
            </div>
        </div>       
        <div class="layui-form-item" >
            <div class="layui-input-block">   
                <button name="ghsubbtn" class="layui-btn  layui-btn-lg layui-btn-normal" lay-submit lay-filter="ghsubbtn">�����ύ����</button>     

                <button type="reset" name="ghresetbtn" class="layui-btn  layui-btn-lg layui-btn-primary">����</button>
            </div>
        </div>
    </div>
</script>
<script id="lbminbox_tmp" type="text/html">
    <div class="layui-tab layui-tab-card" id="lbminbox">
        <ul class="layui-tab-title">
            <li data-tmp="lb" class="layui-this">ѡ������</li>
            <li data-tmp="tj">��������</li>
        </ul>
        <div class="layui-tab-content" id="lbminbox_content">
        </div>
    </div>      
</script>
<script id="lbminbox_lb_tmp" type="text/html">
    <div>
        <div id="lbminsearch" style="margin-top:10px"></div>
        <div id="lbmininfo" style="margin:0"></div>
    </div>
</script>
<script id="lbminbody_tmp" type="text/html">
   {{if data.info.length>0}}
        <table lay-filter="lbmintable">
            <thead>
            <tr >
                <th lay-data="{field:'c_sysid',width:60,fixed:'left'}">��ѡ </th>
                <th lay-data="{field:'regtypename',width:100,sort: true}">����</th>
                <th lay-data="{field:'c_org_m',width:140}">������</th>  
                <th lay-data="{field:'c_em',width:100}">����������</th> 
                <th lay-data="{field:'reg_contact_type',width:250}">���÷�Χ</th>                
                <th lay-data="{field:'c_date',width:120,sort: true}">���ʱ��</th>
                <th lay-data="{field:'c_status',width:175,sort: true}">״̬</th>
                <th lay-data="{field:'btntd',width:100}">����</th>       
            </tr> 
            </thead>
            <tbody>    
            {{each data.info}}
            <tr>
                <td>              
                <input type="radio" data-regtype="{{$value.c_regtype}}" data-rstatus="{{$value.r_status}}" data-type="{{$value.reg_contact_type}}" name="c_sysid"   {{if $value.c_status=="4"}} disabled {{else if $index==0}} checked {{/if}}value="{{$value.c_sysid}}">&nbsp;
               </td>
                <td>{{$value.regtypename}}</td>
                <td>{{$value.c_org_m}}</td>
                <td>{{$value.c_em}}</td>  
                <td>&nbsp;
                {{set t=$value;t.cfg=$data.cfg;t.index=$index}}
                {{include 'regcontacttype_tmp' $value}}</td>  
                <td>{{$value.c_date}}</td>                        
                <td><div class="layui-btn-group">{{include 'statuslist_tmp' $value}}{{include 'statuslistr_tmp' t}}</div></td>            <td>&nbsp;<button type="button" name="modlbminbtn" data-id="{{$value.c_sysid}}" class="layui-btn layui-btn-sm layui-btn-normal">�༭</button></td>
            </tr>  
            {{/each}}     
            </tbody>
        </table>
        <div id="lbminpagebox_mg"></div>       
   {{else}}
    <div class="msg-box warn-msg-box">
        <i class="msg-icon"></i>���κμ�¼
    </div>    
    {{/if}}  
</script>
<script id="lbminsearch_tmp" type="text/html">
    <div class="layui-form" style="margin:0;padding:0">
        <div class="layui-form-item">
            <div class="layui-inline seachitem">
                <label class="layui-form-label"  style="width: 30px;">����</label>
                <div class="layui-input-inline"  style="width: 80px;">
                             
                    <select name="c_regtype">
                        <option value=""></option>     
                        {{each cfg && cfg.regtypepair}}    
                        <option value="{{$index}}">{{$value}}</option>
                        {{/each}}                
                    </select>
                </div>
            </div>
            <div class="layui-inline seachitem">
                <label class="layui-form-label"  style="width: 50px;">������</label>
                <div class="layui-input-inline"  style="width: 100px;">
                      <input type="text" name="c_org_m"  placeholder="��λ/����" autocomplete="off" class="layui-input">
                </div>
            </div>    
                  
            <div class="layui-inline seachitem">
                <label class="layui-form-label"  style="width: 30px;">״̬</label>
                 <div class="layui-input-inline"  style="width: 90px;">                
                    <select name="c_status">
                        <option value="">����״̬</option>     
                        {{each cfg && cfg.statusinfo}} 
                            {{if $value.status_class=="contact_info"}}   
                            <option value="{{$value.status_id}}">{{$value.status_name}}</option>                
                            {{/if}}           
                        {{/each}}                
                    </select>
                </div>
                <div class="layui-input-inline"  style="width: 90px;">                
                    <select name="r_status">
                        <option value="">ʵ��״̬</option>     
                        {{each cfg && cfg.statusinfo}} 
                            {{if $value.status_class=="registant_id"}}   
                            <option value="{{$value.status_id}}">{{$value.status_name}}</option>                
                            {{/if}}           
                        {{/each}}                
                    </select>
                </div>               
            </div>        
            <div class="layui-inline seachitem">
                <label class="layui-form-label"  style="width:30px;">��Χ</label>
                <div class="layui-input-inline"  style="width: 80px;">            
                    <select name="reg_contact_type">
                        <option value=""></option>
                        {{each cfg && cfg.contacttype}}
                            <option value="{{$index}}">{{$value}}</option>
                        {{/each}}
                    </select>
                </div>
            </div>
            <div class="layui-inline seachitem">
                <div class="layui-btn-group">
                <button type="button" name="lbminsearchbtn" class="layui-btn layui-btn-normal" >����</button>
                <button type="button" name="lbminresetbtn" class="layui-btn layui-btn-primary">����</button>
                </div>
                
            </div>
        </div>
    </div>
</script>
    <!--����״̬-->
<script id="ghztbox_lb_tmp" type="text/html">
    <div>
        <div id="ghztsearch" style="margin-top:10px"></div>
        <div id="ghztinfo" style="margin:0"></div>
    </div>
</script>
<script id="ghztbody_tmp" type="text/html">
    {{if data.info.length>0}}
        <table lay-filter="ghzttable">
            <thead>
            <tr >
                <th lay-data="{field:'g_sysid',width:80,sort: true}">��� </th>
                <th lay-data="{field:'strdomain',width:300,sort: true}">����</th>
                <th lay-data="{field:'eppidtype',width:600}">�޸Ķ���</th>
                <th lay-data="{field:'g_status',width:130,sort: true}">����״̬</th>  
                <th lay-data="{field:'c_sysid',width:100,sort: true}">ģ�����</th>
                <th lay-data="{field:'g_date',width:180,sort: true}">���ʱ��</th>
                <th lay-data="{field:'g_enddate',width:180,sort: true}">����ʱ��</th>                
            </tr> 
            </thead>
            <tbody>    
            {{each data.info}}
            <tr>
                <td>{{$value.g_sysid}}</td>
                <td>
                {{if $value.strdomain.indexOf("xn--")>=0}}
                    {{$value.s_memo}}
                {{else}}
                    {{$value.strdomain}}
                {{/if}}
                </td>
                <td>
                <div class="layui-btn-group">
                    {{each $value.eppidtypearr ev ei}}
                        {{if $value.g_status==0 || $value.g_status==2}}
                            <span class="layui-badge layui-bg-gray"><i class="layui-icon layui-icon-log" style="font-size: 14px; color: #666;"></i>&nbsp;{{cfg.eppidtype[ev]}}</span> 
                        {{else}}
                            {{if jsonlength($value.retinfo)>0}}
                                {{if $value.retinfo[ev]}}
                                    {{if $value.retinfo[ev].indexOf("200")>=0}}                         
                                        <button data-msg="{{$value.retinfo[ev]}}" type="button" name="statusbtn" class="layui-btn layui-btn-xs">
                                         <i class="layui-icon layui-icon-ok-circle" style="font-size: 14px; color: #fff;"></i>&nbsp;{{cfg.eppidtype[ev]}}���ɹ�
                                         </button> 
                                    {{else}}
                                         <button data-msg="{{$value.retinfo[ev]}}" type="button" name="statusbtn" class="layui-btn layui-btn-xs layui-btn-danger">
                                         <i class="layui-icon layui-icon-tips" style="font-size: 14px; color: #fff;"></i>&nbsp;{{cfg.eppidtype[ev]}}��ʧ��
                                         </button>                                     
                                    {{/if}} 
                                {{/if}}  
                            {{else}}                 
                                <button data-msg="{{$value.retinfo}}" type="button" name="statusbtn" class="layui-btn layui-btn-xs layui-btn-danger">
                                         <i class="layui-icon layui-icon-tips" style="font-size: 14px; color: #fff;"></i>&nbsp;{{cfg.eppidtype[ev]}}��ʧ��
                                </button>
                            {{/if}}        
                        {{/if}}        
                    {{/each}}
                    {{if $value.eppcmd}}
                        <button type="button" data-index="{{$index}}" name="eppcmdbtn" class="layui-btn layui-btn-xs layui-btn-normal">
                            <i class="layui-icon layui-icon-fonts-code"></i>
                        </button>
                    {{/if}} 
                    </div>
                </td>
                <td>&nbsp;
                    {{if $value.g_status==1}}
                        <span class="layui-badge layui-bg-green">{{$value.status_name}}</span>
                    {{else if $value.g_status==3 || $value.g_status==4}}
                        <span class="layui-badge">{{$value.status_name}}</span>
                    {{else}}
                        <span class="layui-badge layui-bg-gray">{{$value.status_name}}</span>
                    {{/if}}                
                </td>
                <td>{{$value.c_sysid}}</td> 
                <td>{{$value.g_date}}</td>                         
                <td>{{$value.g_enddate}}</td>
                
            </tr>  
            {{/each}}     
            </tbody>
        </table>
        <div id="pagebox_mg"></div>       
    {{else}}
        <div class="msg-box warn-msg-box">
            <i class="msg-icon"></i>���κμ�¼
        </div>    
    {{/if}}  
</script>
<script id="ghztsearch_tmp" type="text/html">
    <div class="layui-form" style="margin:0;padding:0;font-size:14px">
        <div class="layui-form-item">
            <div class="layui-inline seachitem">
                <label class="layui-form-label"  style="width: 40px;">����</label>
                <div class="layui-input-inline"  style="width: 100px;">
                    <input type="text" name="strdomain"  placeholder="����" autocomplete="off" class="layui-input">
                </div>
            </div>                    
            <div class="layui-inline seachitem">
                <label class="layui-form-label"  style="width: 60px;">����״̬</label>
                <div class="layui-input-inline"  style="width: 80px;">                
                    <select name="g_status">
                        <option value=""></option>     
                        {{each cfg && cfg.statusinfo}} 
                            {{if $value.status_class=="contact_ghlist"}}   
                            <option value="{{$value.status_id}}">{{$value.status_name}}</option>                
                            {{/if}}           
                        {{/each}}                
                    </select>
                </div>
            </div>        
            <div class="layui-inline seachitem">
                <label class="layui-form-label"  style="width: 60px;">���ʱ��</label>
                <div class="layui-input-inline" style="width: 130px;">
                    <input type="text" name="g_date_begin" placeholder="��ʼʱ��" autocomplete="off" class="layui-input dropdate">
                </div>
                <div class="layui-form-mid">-</div>
                <div class="layui-input-inline" style="width: 130px;">
                    <input type="text" name="g_date_end" placeholder="����ʱ��" autocomplete="off" class="layui-input dropdate">
                </div>
            </div>
            <div class="layui-inline seachitem">
                <div class="layui-input-inline"  style="width: 200px;">
                    <button type="button" name="searchbtn" class="layui-btn layui-btn-normal" >����</button>
                    <button type="reset" name="ghztresetbtn" class="layui-btn layui-btn-primary">����</button>
                </div>                
            </div>   
        </div>    
    </div>
</script>
<script id="eppcmdbody_tmp" type="text/html">
    {{if $data.length>0}}
        <table lay-filter="eppcmdtable">
            <thead>
            <tr >
                <th lay-data="{field:'g_sysid',width:70,sort: true}">��� </th>
                <th lay-data="{field:'eppcmd',width:300}">����</th>
                <th lay-data="{field:'result',width:200}">����</th>
                
                <th lay-data="{field:'register',width:100,sort: true}">�ӿ�</th>  
                <th lay-data="{field:'ipaddr',width:120,sort: true}">ִ�з�����</th>       
                <th lay-data="{field:'time',width:100,sort: true}">ʱ��</th>                
            </tr> 
            </thead>
            <tbody>    
            {{each $data}}
            <tr>
                <td>{{$index}}</td>
                <td>{{$value.eppcmd}}</td>
                <td>{{@$value.result}}</td>            
                <td>{{$value.register}} </td>
                <td>{{$value.ipaddr}}    </td>    
                <td>{{$value.time}}</td>
            </tr>  
            {{/each}}     
            </tbody>
        </table>   
    {{else}}
        <div class="msg-box warn-msg-box">
            <i class="msg-icon"></i>���κμ�¼
        </div>    
    {{/if}}  
</script>
<script id="domainmodibox_tmp" type="text/html">
    <div class="layui-tab layui-tab-brief layui-form"  id="domainmodibox">
        
        <div class="layui-form-item">
            <label class="layui-form-label" style="width:auto;font-size:16px">����:</label>            
             <div id="strdomain" class="layui-form-mid layui-text" style="font-size:16px">                  
             </div>            
        </div>
        <ul class="layui-tab-title" style="margin:10px 0 ">
            {{each cfg.eppidtype}}
            <li data-tmp="{{$index}}">{{$value}}</li>
            {{/each}}
        </ul>        
        <div class="layui-tab-content" id="domainmodibox_body"> </div>
    </div>
</script>
