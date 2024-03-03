#ifndef CURVEDWORLD_SPIRALVERTICAL_X_NEGATIVE_ID24_CGINC
#define CURVEDWORLD_SPIRALVERTICAL_X_NEGATIVE_ID24_CGINC

uniform float3 CurvedWorld_SpiralVertical_X_Negative_ID24_PivotPoint;
uniform float3 CurvedWorld_SpiralVertical_X_Negative_ID24_RotationCenter;
uniform float CurvedWorld_SpiralVertical_X_Negative_ID24_BendAngle;
uniform float CurvedWorld_SpiralVertical_X_Negative_ID24_BendMinimumRadius;

                 
#include "../../Core/Core.cginc"                           
             
      
////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                                Main Method                                 //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
void CurvedWorld_SpiralVertical_X_Negative_ID24(inout float4 vertexOS)
{
    CurvedWorld_SpiralVertical_X_Negative(vertexOS, 
							CurvedWorld_SpiralVertical_X_Negative_ID24_PivotPoint,
	                        CurvedWorld_SpiralVertical_X_Negative_ID24_RotationCenter,                            
							CurvedWorld_SpiralVertical_X_Negative_ID24_BendAngle,
							CurvedWorld_SpiralVertical_X_Negative_ID24_BendMinimumRadius);
}

void CurvedWorld_SpiralVertical_X_Negative_ID24(inout float4 vertexOS, inout float3 normalOS, float4 tangent)
{
    CurvedWorld_SpiralVertical_X_Negative(vertexOS, 
                            normalOS, 
                            tangent,
							CurvedWorld_SpiralVertical_X_Negative_ID24_PivotPoint,
                            CurvedWorld_SpiralVertical_X_Negative_ID24_RotationCenter,                            
							CurvedWorld_SpiralVertical_X_Negative_ID24_BendAngle,
							CurvedWorld_SpiralVertical_X_Negative_ID24_BendMinimumRadius);
}

void CurvedWorld_SpiralVertical_X_Negative_ID24(inout float3 vertexOS)
{
    float4 vertex = float4(vertexOS, 1);
    CurvedWorld_SpiralVertical_X_Negative_ID24(vertex);

    vertexOS.xyz = vertex.xyz;
}

void CurvedWorld_SpiralVertical_X_Negative_ID24(inout float3 vertexOS, inout float3 normalOS, float4 tangent)
{
    float4 vertex = float4(vertexOS, 1);
    CurvedWorld_SpiralVertical_X_Negative_ID24(vertex, normalOS, tangent);

    vertexOS.xyz = vertex.xyz;
} 

////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                               SubGraph Methods                             //
//                                                                            // 
////////////////////////////////////////////////////////////////////////////////
void CurvedWorld_SpiralVertical_X_Negative_ID24_float(float3 vertexOS, out float3 retVertex)
{
    CurvedWorld_SpiralVertical_X_Negative_ID24(vertexOS); 	

    retVertex = vertexOS.xyz;
}

void CurvedWorld_SpiralVertical_X_Negative_ID24_half(half3 vertexOS, out half3 retVertex)
{
    CurvedWorld_SpiralVertical_X_Negative_ID24(vertexOS); 	

    retVertex = vertexOS.xyz;
}

void CurvedWorld_SpiralVertical_X_Negative_ID24_float(float3 vertexOS, float3 normalOS, float4 tangent, out float3 retVertex, out float3 retNormal)
{
	CurvedWorld_SpiralVertical_X_Negative_ID24(vertexOS, normalOS, tangent); 	

    retVertex = vertexOS.xyz;
    retNormal = normalOS.xyz;
}

void CurvedWorld_SpiralVertical_X_Negative_ID24_half(half3 vertexOS, half3 normalOS, half4 tangent, out half3 retVertex, out float3 retNormal)
{
	CurvedWorld_SpiralVertical_X_Negative_ID24(vertexOS, normalOS, tangent); 	

    retVertex = vertexOS.xyz;
    retNormal = normalOS.xyz;	
}     

#endif
