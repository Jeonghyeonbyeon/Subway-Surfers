#ifndef CURVEDWORLD_LITTLEPLANET_X_ID15_CGINC
#define CURVEDWORLD_LITTLEPLANET_X_ID15_CGINC

uniform float3 CurvedWorld_LittlePlanet_X_ID15_PivotPoint;
uniform float CurvedWorld_LittlePlanet_X_ID15_BendSize;    
uniform float CurvedWorld_LittlePlanet_X_ID15_BendOffset;
  
                 
#include "../../Core/Core.cginc"                           
             
      
////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                                Main Method                                 //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
void CurvedWorld_LittlePlanet_X_ID15(inout float4 vertexOS)
{
    CurvedWorld_LittlePlanet_X(vertexOS, 
	                        CurvedWorld_LittlePlanet_X_ID15_PivotPoint,
							CurvedWorld_LittlePlanet_X_ID15_BendSize,
							CurvedWorld_LittlePlanet_X_ID15_BendOffset);
}

void CurvedWorld_LittlePlanet_X_ID15(inout float4 vertexOS, inout float3 normalOS, float4 tangent)
{
    CurvedWorld_LittlePlanet_X(vertexOS, 
                            normalOS, 
                            tangent,
                            CurvedWorld_LittlePlanet_X_ID15_PivotPoint,
                            CurvedWorld_LittlePlanet_X_ID15_BendSize,
                            CurvedWorld_LittlePlanet_X_ID15_BendOffset);
}    

void CurvedWorld_LittlePlanet_X_ID15(inout float3 vertexOS)
{
    float4 vertex = float4(vertexOS, 1);
    CurvedWorld_LittlePlanet_X_ID15(vertex);

    vertexOS.xyz = vertex.xyz;
}

void CurvedWorld_LittlePlanet_X_ID15(inout float3 vertexOS, inout float3 normalOS, float4 tangent)
{
    float4 vertex = float4(vertexOS, 1);
    CurvedWorld_LittlePlanet_X_ID15(vertex, normalOS, tangent);

    vertexOS.xyz = vertex.xyz;
}  
                  
////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                               SubGraph Methods                             //
//                                                                            // 
////////////////////////////////////////////////////////////////////////////////
void CurvedWorld_LittlePlanet_X_ID15_float(float3 vertexOS, out float3 retVertex)
{
    CurvedWorld_LittlePlanet_X_ID15(vertexOS); 	

    retVertex = vertexOS.xyz;
}

void CurvedWorld_LittlePlanet_X_ID15_half(half3 vertexOS, out half3 retVertex)
{
    CurvedWorld_LittlePlanet_X_ID15(vertexOS); 	

    retVertex = vertexOS.xyz;
}

void CurvedWorld_LittlePlanet_X_ID15_float(float3 vertexOS, float3 normalOS, float4 tangent, out float3 retVertex, out float3 retNormal)
{
	CurvedWorld_LittlePlanet_X_ID15(vertexOS, normalOS, tangent); 	

    retVertex = vertexOS.xyz;
    retNormal = normalOS.xyz;
}

void CurvedWorld_LittlePlanet_X_ID15_half(half3 vertexOS, half3 normalOS, half4 tangent, out half3 retVertex, out float3 retNormal)
{
	CurvedWorld_LittlePlanet_X_ID15(vertexOS, normalOS, tangent); 	

    retVertex = vertexOS.xyz;
    retNormal = normalOS.xyz;	
}     

#endif
