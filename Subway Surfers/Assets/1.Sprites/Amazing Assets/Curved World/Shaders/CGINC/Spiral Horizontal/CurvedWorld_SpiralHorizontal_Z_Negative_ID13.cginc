#ifndef CURVEDWORLD_SPIRALHORIZONTAL_Z_NEGATIVE_ID13_CGINC
#define CURVEDWORLD_SPIRALHORIZONTAL_Z_NEGATIVE_ID13_CGINC

uniform float3 CurvedWorld_SpiralHorizontal_Z_Negative_ID13_PivotPoint;
uniform float3 CurvedWorld_SpiralHorizontal_Z_Negative_ID13_RotationCenter;
uniform float CurvedWorld_SpiralHorizontal_Z_Negative_ID13_BendAngle;
uniform float CurvedWorld_SpiralHorizontal_Z_Negative_ID13_BendMinimumRadius;

                 
#include "../../Core/Core.cginc"                           
             
      
////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                                Main Method                                 //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
void CurvedWorld_SpiralHorizontal_Z_Negative_ID13(inout float4 vertexOS)
{
    CurvedWorld_SpiralHorizontal_Z_Negative(vertexOS, 
							CurvedWorld_SpiralHorizontal_Z_Negative_ID13_PivotPoint,
	                        CurvedWorld_SpiralHorizontal_Z_Negative_ID13_RotationCenter,                            
							CurvedWorld_SpiralHorizontal_Z_Negative_ID13_BendAngle,
							CurvedWorld_SpiralHorizontal_Z_Negative_ID13_BendMinimumRadius);
}

void CurvedWorld_SpiralHorizontal_Z_Negative_ID13(inout float4 vertexOS, inout float3 normalOS, float4 tangent)
{
    CurvedWorld_SpiralHorizontal_Z_Negative(vertexOS, 
                            normalOS, 
                            tangent,
							CurvedWorld_SpiralHorizontal_Z_Negative_ID13_PivotPoint,
                            CurvedWorld_SpiralHorizontal_Z_Negative_ID13_RotationCenter,                            
							CurvedWorld_SpiralHorizontal_Z_Negative_ID13_BendAngle,
							CurvedWorld_SpiralHorizontal_Z_Negative_ID13_BendMinimumRadius);
}

void CurvedWorld_SpiralHorizontal_Z_Negative_ID13(inout float3 vertexOS)
{
    float4 vertex = float4(vertexOS, 1);
    CurvedWorld_SpiralHorizontal_Z_Negative_ID13(vertex);

    vertexOS.xyz = vertex.xyz;
}

void CurvedWorld_SpiralHorizontal_Z_Negative_ID13(inout float3 vertexOS, inout float3 normalOS, float4 tangent)
{
    float4 vertex = float4(vertexOS, 1);
    CurvedWorld_SpiralHorizontal_Z_Negative_ID13(vertex, normalOS, tangent);

    vertexOS.xyz = vertex.xyz;
} 

////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                               SubGraph Methods                             //
//                                                                            // 
////////////////////////////////////////////////////////////////////////////////
void CurvedWorld_SpiralHorizontal_Z_Negative_ID13_float(float3 vertexOS, out float3 retVertex)
{
    CurvedWorld_SpiralHorizontal_Z_Negative_ID13(vertexOS); 	

    retVertex = vertexOS.xyz;
}

void CurvedWorld_SpiralHorizontal_Z_Negative_ID13_half(half3 vertexOS, out half3 retVertex)
{
    CurvedWorld_SpiralHorizontal_Z_Negative_ID13(vertexOS); 	

    retVertex = vertexOS.xyz;
}

void CurvedWorld_SpiralHorizontal_Z_Negative_ID13_float(float3 vertexOS, float3 normalOS, float4 tangent, out float3 retVertex, out float3 retNormal)
{
	CurvedWorld_SpiralHorizontal_Z_Negative_ID13(vertexOS, normalOS, tangent); 	

    retVertex = vertexOS.xyz;
    retNormal = normalOS.xyz;
}

void CurvedWorld_SpiralHorizontal_Z_Negative_ID13_half(half3 vertexOS, half3 normalOS, half4 tangent, out half3 retVertex, out float3 retNormal)
{
	CurvedWorld_SpiralHorizontal_Z_Negative_ID13(vertexOS, normalOS, tangent); 	

    retVertex = vertexOS.xyz;
    retNormal = normalOS.xyz;	
}     

#endif
