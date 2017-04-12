# ItInovation
# Tools for generate xml in wsdl file.

#xml structure:

<content>
  <fields name="University">
    <field name="Adress" type="complextype">
      <field name="Country" type="string" size="" label=""/>
      <field name="City" type="string" size="" label=""/>
      <field name="Zone" type="string" size="" label=""/>
    </field>
    <field name="Name" type="string" size="" label=""/>
    <field name="DateCreate" type="datetime" size="" label=""/>
  </fields>
  <service>
    <operation name="CreateUniversity"/>
    <operation name="UpdateUniversity"/>
    <operation name="DeleteUniversity"/>
    <operation name="SelectUniversity"/>
  </service>
 </content>
