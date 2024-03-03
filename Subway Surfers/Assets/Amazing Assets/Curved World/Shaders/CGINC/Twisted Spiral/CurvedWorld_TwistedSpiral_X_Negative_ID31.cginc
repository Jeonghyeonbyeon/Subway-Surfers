#ifndef CURVEDWORLD_TWISTEDSPIRAL_X_NEGATIVE_ID31_CGINC
#define CURVEDWORLD_TWISTEDSPIRAL_X_NEGATIVE_ID31_CGINC

uniform float3 CurvedWorld_TwistedSpiral_X_Negative_ID31_PivotPoint;
uniform float3 CurvedWorld_TwistedSpiral_X_Negative_ID31_RotationAxis;
uniform float3 CurvedWorld_TwistedSpiral_X_Negative_ID31_BendSize;    
uniform float3 CurvedWorld_TwistedSpiral_X_Negative_ID31_BendOffset;
  
                 
#include "../../Core/Core.cginc"                           
             
      
////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                                Main Method                                 //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
void CurvedWorld_TwistedSpiral_X_Negative_ID31(inout float4 vertexOS)
{
    CurvedWorld_TwistedSpiral_X_Negative(vertexOS, 
	                        CurvedWorld_TwistedSpiral_X_Negative_ID31_PivotPoint,
                            CurvedWorld_TwistedSpiral_X_Negative_ID31_RotationAxis,
							CurvedWorld_TwistedSpiral_X_Negative_ID31_BendSize,
							CurvedWorld_TwistedSpiral_X_Negative_ID31_BendOffset);
}

void CurvedWorld_TwistedSpiral_X_Negative_ID31(inout float4 vertexOS, inout float3 normalOS, float4 tangent)
{
    CurvedWorld_TwistedSpiral_X_Negative(vertexOS, 
                            normalOS, 
                            tangent,
                            CurvedWorld_TwistedSpiral_X_Negative_ID31_PivotPoint,
                            CurvedWorld_TwistedSpiral_X_Negative_ID31_RotationAxis,
							CurvedWorld_TwistedSpiral_X_Negative_ID31_BendSize,
							CurvedWorld_TwistedSpiral_X_Negative_ID31_BendOffset);
}    

void CurvedWorld_TwistedSpiral_X_Negative_ID31(inout float3 vertexOS)
{
    float4 vertex = float4(vertexOS, 1);
    CurvedWorld_TwistedSpiral_X_Negative_ID31(vertex);

    vertexOS.xyz = vertex.xyz;
}

void CurvedWorld_TwistedSpiral_X_Negative_ID31(inout float3 vertexOS, inout float3 normalOS, float4 tangent)
{
    float4 vertex = float4(vertexOS, 1);
    CurvedWorld_TwistedSpiral_X_Negative_ID31(vertex, normalOS, tangent);

    vertexOS.xyz = vertex.xyz;
}  
                  
////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                               SubGraph Methods                             //
//                                                                            // 
////////////////////////////////////////////////////////////////////////////////
void CurvedWorld_TwistedSpiral_X_Negative_ID31_float(float3 vertexOS, out float3 retVertex)
{
    CurvedWorld_TwistedSpiral_X_Negative_ID31(vertexOS); 	

    retVertex = vertexOS.xyz;
}

void CurvedWorld_TwistedSpiral_X_Negative_ID31_half(half3 vertexOS, out half3 retVertex)
{
    CurvedWorld_TwistedSpiral_X_Negative_ID31(vertexOS); 	

    retVertex = vertexOS.xyz;
}

void CurvedWorld_TwistedSpiral_X_Negative_ID31_float(float3 vertexOS, float3 normalOS, float4 tangent, out float3 retVertex, out float3 retNormal)
{
	CurvedWorld_TwistedSpiral_X_Negative_ID31(vertexOS, normalOS, tangent); 	

    retVertex = vertexOS.xyz;
    retNormal = normalOS.xyz;
}

void CurvedWorld_TwistedSpiral_X_Negative_ID31_half(half3 vertexOS, half3 normalOS, half4 tangent, out half3 retVertex, out float3 retNormal)
{
	CurvedWorld_TwistedSpiral_X_Negative_ID31(vertexOS, normalOS, tangent); 	

    retVertex = vertexOS.xyz;
    retNormal = normalOS.xyz;	
}     

#endif
