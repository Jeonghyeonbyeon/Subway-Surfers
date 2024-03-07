#ifndef CURVEDWORLD_LITTLEPLANET_Z_ID30_CGINC
#define CURVEDWORLD_LITTLEPLANET_Z_ID30_CGINC

uniform float3 CurvedWorld_LittlePlanet_Z_ID30_PivotPoint;
uniform float CurvedWorld_LittlePlanet_Z_ID30_BendSize;    
uniform float CurvedWorld_LittlePlanet_Z_ID30_BendOffset;
  
                 
#include "../../Core/Core.cginc"                           
             
      
////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                                Main Method                                 //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
void CurvedWorld_LittlePlanet_Z_ID30(inout float4 vertexOS)
{
    CurvedWorld_LittlePlanet_Z(vertexOS, 
	                        CurvedWorld_LittlePlanet_Z_ID30_PivotPoint,
							CurvedWorld_LittlePlanet_Z_ID30_BendSize,
							CurvedWorld_LittlePlanet_Z_ID30_BendOffset);
}

void CurvedWorld_LittlePlanet_Z_ID30(inout float4 vertexOS, inout float3 normalOS, float4 tangent)
{
    CurvedWorld_LittlePlanet_Z(vertexOS, 
                            normalOS, 
                            tangent,
                            CurvedWorld_LittlePlanet_Z_ID30_PivotPoint,
                            CurvedWorld_LittlePlanet_Z_ID30_BendSize,
                            CurvedWorld_LittlePlanet_Z_ID30_BendOffset);
}    

void CurvedWorld_LittlePlanet_Z_ID30(inout float3 vertexOS)
{
    float4 vertex = float4(vertexOS, 1);
    CurvedWorld_LittlePlanet_Z_ID30(vertex);

    vertexOS.xyz = vertex.xyz;
}

void CurvedWorld_LittlePlanet_Z_ID30(inout float3 vertexOS, inout float3 normalOS, float4 tangent)
{
    float4 vertex = float4(vertexOS, 1);
    CurvedWorld_LittlePlanet_Z_ID30(vertex, normalOS, tangent);

    vertexOS.xyz = vertex.xyz;
}  
                  
////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                               SubGraph Methods                             //
//                                                                            // 
////////////////////////////////////////////////////////////////////////////////
void CurvedWorld_LittlePlanet_Z_ID30_float(float3 vertexOS, out float3 retVertex)
{
    CurvedWorld_LittlePlanet_Z_ID30(vertexOS); 	

    retVertex = vertexOS.xyz;
}

void CurvedWorld_LittlePlanet_Z_ID30_half(half3 vertexOS, out half3 retVertex)
{
    CurvedWorld_LittlePlanet_Z_ID30(vertexOS); 	

    retVertex = vertexOS.xyz;
}

void CurvedWorld_LittlePlanet_Z_ID30_float(float3 vertexOS, float3 normalOS, float4 tangent, out float3 retVertex, out float3 retNormal)
{
	CurvedWorld_LittlePlanet_Z_ID30(vertexOS, normalOS, tangent); 	

    retVertex = vertexOS.xyz;
    retNormal = normalOS.xyz;
}

void CurvedWorld_LittlePlanet_Z_ID30_half(half3 vertexOS, half3 normalOS, half4 tangent, out half3 retVertex, out float3 retNormal)
{
	CurvedWorld_LittlePlanet_Z_ID30(vertexOS, normalOS, tangent); 	

    retVertex = vertexOS.xyz;
    retNormal = normalOS.xyz;	
}     

#endif
