root = exports ? this

root.testCollada = """
<?xml version="1.0"?>
<COLLADA xmlns="http://www.collada.org/2005/11/COLLADASchema" version="1.4.1">
    <asset>
        <contributor>
            <author>alorino</author>
            <authoring_tool>Maya 7.0 | ColladaMaya v2.01 Jun  9 2006 at 16:08:19 | FCollada v1.11</authoring_tool>
            <comments>Collada Maya Export Options: bakeTransforms=0;exportPolygonMeshes=1;bakeLighting=0;isSampling=0;
curveConstrainSampling=0;exportCameraAsLookat=0;
exportLights=1;exportCameras=1;exportJointsAndSkin=1;
exportAnimations=1;exportTriangles=0;exportInvisibleNodes=0;
exportNormals=1;exportTexCoords=1;exportVertexColors=1;exportTangents=0;
exportTexTangents=0;exportConstraints=0;exportPhysics=0;exportXRefs=1;
dereferenceXRefs=0;cameraXFov=0;cameraYFov=1</comments>
            <copyright>
Copyright 2006 Sony Computer Entertainment Inc.
Licensed under the SCEA Shared Source License, Version 1.0 (the
&quot;License&quot;); you may not use this file except in compliance with the
License. You may obtain a copy of the License at:
http://research.scea.com/scea_shared_source_license.html 
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an &quot;AS IS&quot; BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
</copyright>
        </contributor>
        <created>2006-06-21T21:23:22Z</created>
        <modified>2006-06-21T21:23:22Z</modified>
        <unit meter="0.01" name="centimeter"/>
        <up_axis>Y_UP</up_axis>
    </asset>
    <library_cameras>
        <camera id="PerspCamera" name="PerspCamera">
            <optics>
                <technique_common>
                    <perspective>
                        <yfov>37.8493</yfov>
                        <aspect_ratio>1</aspect_ratio>
                        <znear>10</znear>
                        <zfar>1000</zfar>
                    </perspective>
                </technique_common>
            </optics>
        </camera>
        <camera id="testCameraShape" name="testCameraShape">
            <optics>
                <technique_common>
                    <perspective>
                        <yfov>37.8501</yfov>
                        <aspect_ratio>1</aspect_ratio>
                        <znear>0.01</znear>
                        <zfar>1000</zfar>
                    </perspective>
                </technique_common>
            </optics>
        </camera>
    </library_cameras>
    <library_lights>
        <light id="light-lib" name="light">
            <technique_common>
                <point>
                    <color>1 1 1</color>
                    <constant_attenuation>1</constant_attenuation>
                    <linear_attenuation>0</linear_attenuation>
                    <quadratic_attenuation>0</quadratic_attenuation>
                </point>
            </technique_common>
            <technique profile="MAX3D">
                <intensity>1.000000</intensity>
            </technique>
        </light>
        <light id="pointLightShape1-lib" name="pointLightShape1">
            <technique_common>
                <point>
                    <color>1 1 1</color>
                    <constant_attenuation>1</constant_attenuation>
                    <linear_attenuation>0</linear_attenuation>
                    <quadratic_attenuation>0</quadratic_attenuation>
                </point>
            </technique_common>
        </light>
    </library_lights>
    <library_materials>
        <material id="Blue" name="Blue">
            <instance_effect url="#Blue-fx"/>
        </material>
    </library_materials>
    <library_effects>
        <effect id="Blue-fx">
            <profile_COMMON>
                <technique sid="common">
                    <phong>
                        <emission>
                            <color>0 0 0 1</color>
                        </emission>
                        <ambient>
                            <color>0 0 0 1</color>
                        </ambient>
                        <diffuse>
                            <color>0.137255 0.403922 0.870588 1</color>
                        </diffuse>
                        <specular>
                            <color>0.5 0.5 0.5 1</color>
                        </specular>
                        <shininess>
                            <float>16</float>
                        </shininess>
                        <reflective>
                            <color>0 0 0 1</color>
                        </reflective>
                        <reflectivity>
                            <float>0.5</float>
                        </reflectivity>
                        <transparent>
                            <color>0 0 0 1</color>
                        </transparent>
                        <transparency>
                            <float>1</float>
                        </transparency>
                        <index_of_refraction>
                            <float>0</float>
                        </index_of_refraction>
                    </phong>
                </technique>
            </profile_COMMON>
        </effect>
    </library_effects>
    <library_geometries>
        <geometry id="box-lib" name="box">
            <mesh>
                <source id="box-lib-positions" name="position">
                    <float_array id="box-lib-positions-array" count="24">-50 50 50 50 50 50 -50 -50 50 50 -50 50 -50 50 -50 50 50 -50 -50 -50 -50 50 -50 -50</float_array>
                    <technique_common>
                        <accessor count="8" offset="0" source="#box-lib-positions-array" stride="3">
                            <param name="X" type="float"></param>
                            <param name="Y" type="float"></param>
                            <param name="Z" type="float"></param>
                        </accessor>
                    </technique_common>
                </source>
                <source id="box-lib-normals" name="normal">
                    <float_array id="box-lib-normals-array" count="72">0 0 1 0 0 1 0 0 1 0 0 1 0 1 0 0 1 0 0 1 0 0 1 0 0 -1 0 0 -1 0 0 -1 0 0 -1 0 -1 0 0 -1 0 0 -1 0 0 -1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 0 0 -1 0 0 -1 0 0 -1 0 0 -1</float_array>
                    <technique_common>
                        <accessor count="24" offset="0" source="#box-lib-normals-array" stride="3">
                            <param name="X" type="float"></param>
                            <param name="Y" type="float"></param>
                            <param name="Z" type="float"></param>
                        </accessor>
                    </technique_common>
                </source>
                <vertices id="box-lib-vertices">
                    <input semantic="POSITION" source="#box-lib-positions"/>
                </vertices>
                <polylist count="6" material="BlueSG">
                    <input offset="0" semantic="VERTEX" source="#box-lib-vertices"/>
                    <input offset="1" semantic="NORMAL" source="#box-lib-normals"/>
                    <vcount>4 4 4 4 4 4</vcount>
                    <p>0 0 2 1 3 2 1 3 0 4 1 5 5 6 4 7 6 8 7 9 3 10 2 11 0 12 4 13 6 14 2 15 3 16 7 17 5 18 1 19 5 20 7 21 6 22 4 23</p>
                </polylist>
            </mesh>
        </geometry>
    </library_geometries>
    <library_visual_scenes>
        <visual_scene id="VisualSceneNode" name="untitled">
            <node id="Camera" name="Camera">
                <translate sid="translate">-427.749 333.855 655.017</translate>
                <rotate sid="rotateY">0 1 0 -33</rotate>
                <rotate sid="rotateX">1 0 0 -22.1954</rotate>
                <rotate sid="rotateZ">0 0 1 0</rotate>
                <instance_camera url="#PerspCamera"/>
            </node>
            <node id="Light" name="Light">
                <translate sid="translate">-500 1000 400</translate>
                <rotate sid="rotateZ">0 0 1 0</rotate>
                <rotate sid="rotateY">0 1 0 0</rotate>
                <rotate sid="rotateX">1 0 0 0</rotate>
                <instance_light url="#light-lib"/>
            </node>
            <node id="Box" name="Box">
                <rotate sid="rotateZ">0 0 1 0</rotate>
                <rotate sid="rotateY">0 1 0 0</rotate>
                <rotate sid="rotateX">1 0 0 0</rotate>
                <instance_geometry url="#box-lib">
                    <bind_material>
                        <technique_common>
                            <instance_material symbol="BlueSG" target="#Blue"/>
                        </technique_common>
                    </bind_material>
                </instance_geometry>
            </node>
            <node id="testCamera" name="testCamera">
                <translate sid="translate">-427.749 333.855 655.017</translate>
                <rotate sid="rotateY">0 1 0 -33</rotate>
                <rotate sid="rotateX">1 0 0 -22.1954</rotate>
                <rotate sid="rotateZ">0 0 1 0</rotate>
                <instance_camera url="#testCameraShape"/>
            </node>
            <node id="pointLight1" name="pointLight1">
                <translate sid="translate">3 4 10</translate>
                <rotate sid="rotateZ">0 0 1 0</rotate>
                <rotate sid="rotateY">0 1 0 0</rotate>
                <rotate sid="rotateX">1 0 0 0</rotate>
                <instance_light url="#pointLightShape1-lib"/>
            </node>
        </visual_scene>
    </library_visual_scenes>
    <scene>
        <instance_visual_scene url="#VisualSceneNode"/>
    </scene>
</COLLADA>
"""