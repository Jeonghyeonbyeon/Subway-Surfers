#ifndef CURVEDWORLD_CORE_CGINC
#define CURVEDWORLD_CORE_CGINC


//Checking used render pipeline. If "Common.hlsl" is included it means that shader is for SRP. (Should be a better way for detecting SRP!)
#ifdef UNITY_COMMON_INCLUDED
	#ifndef SCRIPTABLE_RENDER_PIPELINE
	#define SCRIPTABLE_RENDER_PIPELINE
	#endif
#endif


#include "Utility.cginc"


////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                             Classic Runner                                 //
//                                                                            //
//////////////////////////////////////////////////////////////////////////////// 
void CurvedWorld_ClassicRunner_X_Positive(inout float4 inVertexOS, float3 pivotPoint, float2 bendSize, float2 bendOffset)
{
    float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	positionWS -= pivotPoint;

	float2 offset = max(float2(0, 0), positionWS.xx - bendOffset.xy);
	offset *= offset;
	positionWS = float3(0.0f, bendSize.x * offset.x, -bendSize.y * offset.y) * 0.001;
	

	
	inVertexOS.xyz += CurvedWorld_WorldToObject(float4(positionWS, 0), 0);
}

void CurvedWorld_ClassicRunner_X_Positive(inout float4 inVertexOS, inout float3 normalOS, float4 tangentOS, float3 pivotPoint, float2 bendSize, float2 bendOffset)
{
	float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	float3 normalWS   = CurvedWorld_ObjectToWorldNormal(normalOS);
	float3 tangentWS  = CurvedWorld_ObjectToWorldTangent(tangentOS.xyz);
	float3 binormalWS = cross(tangentWS, normalWS);


	float3 v0 = positionWS - pivotPoint;
	float3 v1 = v0 + tangentWS;
	float3 v2 = v0 + binormalWS;
 

	float2 offset = max(float2(0, 0), v0.xx - bendOffset.xy);
	offset *= offset;
	float3 transformedVertex = float3(0.0f, bendSize.x * offset.x, -bendSize.y * offset.y) * 0.001;
	v0 += transformedVertex;			


	offset = max(float2(0, 0), v1.xx - bendOffset.xy);
	offset *= offset;
	v1 += float3(0.0f, bendSize.x * offset.x, -bendSize.y * offset.y) * 0.001;
			

	offset = max(float2(0, 0), v2.xx - bendOffset.xy);
	offset *= offset;
	v2 += float3(0.0f, bendSize.x * offset.x, -bendSize.y * offset.y) * 0.001;


	
	inVertexOS.xyz += CurvedWorld_WorldToObject(float4(transformedVertex, 0), 0);	

	normalOS = CurvedWorld_WorldToObjectNormal(normalize(cross(v2 - v0, v1 - v0)));
}

void CurvedWorld_ClassicRunner_X_Negative(inout float4 inVertexOS, float3 pivotPoint, float2 bendSize, float2 bendOffset)
{
    float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	positionWS -= pivotPoint;

	float2 offset = min(float2(0, 0), positionWS.xx + bendOffset.xy);
	offset *= offset;
	positionWS = float3(0.0f, bendSize.x * offset.x, bendSize.y * offset.y) * 0.001;



	inVertexOS.xyz += CurvedWorld_WorldToObject(float4(positionWS, 0), 0);
}

void CurvedWorld_ClassicRunner_X_Negative(inout float4 inVertexOS, inout float3 normalOS, float4 tangentOS, float3 pivotPoint, float2 bendSize, float2 bendOffset)
{
	float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	float3 normalWS   = CurvedWorld_ObjectToWorldNormal(normalOS);
	float3 tangentWS  = CurvedWorld_ObjectToWorldTangent(tangentOS.xyz);
	float3 binormalWS = cross(tangentWS, normalWS);


	float3 v0 = positionWS - pivotPoint;
	float3 v1 = v0 + tangentWS;
	float3 v2 = v0 + binormalWS;
	 

	float2 offset = min(float2(0, 0), v0.xx + bendOffset.xy);
	offset *= offset;
	float3 transformedVertex = float3(0.0f, bendSize.x * offset.x, bendSize.y * offset.y) * 0.001;
	v0 += transformedVertex;
			

	offset = min(float2(0, 0), v1.xx + bendOffset.xy);
	offset *= offset;
	v1 += float3(0.0f, bendSize.x * offset.x, bendSize.y * offset.y) * 0.001;

			
	offset = min(float2(0, 0), v2.xx + bendOffset.xy);
	offset *= offset;
	v2 += float3(0.0f, bendSize.x * offset.x, bendSize.y * offset.y) * 0.001;



	inVertexOS.xyz += CurvedWorld_WorldToObject(float4(transformedVertex, 0), 0);

	normalOS = CurvedWorld_WorldToObjectNormal(normalize(cross(v2 - v0, v1 - v0)));
}

void CurvedWorld_ClassicRunner_Z_Positive(inout float4 inVertexOS, float3 pivotPoint, float2 bendSize, float2 bendOffset)
{
    float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	positionWS -= pivotPoint;

	float2 offset = max(float2(0, 0), positionWS.zz - bendOffset.xy);
	offset *= offset;
	positionWS = float3(bendSize.y * offset.y, bendSize.x * offset.x, 0.0f) * 0.001;

	
	
	inVertexOS.xyz += CurvedWorld_WorldToObject(float4(positionWS, 0), 0);
}

void CurvedWorld_ClassicRunner_Z_Positive(inout float4 inVertexOS, inout float3 normalOS, float4 tangentOS, float3 pivotPoint, float2 bendSize, float2 bendOffset)
{
	float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	float3 normalWS   = CurvedWorld_ObjectToWorldNormal(normalOS);
	float3 tangentWS  = CurvedWorld_ObjectToWorldTangent(tangentOS.xyz);
	float3 binormalWS = cross(tangentWS, normalWS);


	float3 v0 = positionWS - pivotPoint;
	float3 v1 = v0 + tangentWS;
	float3 v2 = v0 + binormalWS;
 

	float2 offset = max(float2(0, 0), v0.zz - bendOffset.xy);
	offset *= offset;
	float3 transformedVertex = float3(bendSize.y * offset.y, bendSize.x * offset.x, 0.0f) * 0.001;
	v0 += transformedVertex;
			

	offset = max(float2(0, 0), v1.zz - bendOffset.xy);
	offset *= offset;
	v1 += float3(bendSize.y * offset.y, bendSize.x * offset.x, 0.0f) * 0.001; 

			
	offset = max(float2(0, 0), v2.zz - bendOffset.xy);
	offset *= offset;
	v2 += float3(bendSize.y * offset.y, bendSize.x * offset.x, 0.0f) * 0.001; 


	
	inVertexOS.xyz += CurvedWorld_WorldToObject(float4(transformedVertex, 0), 0);

	normalOS = CurvedWorld_WorldToObjectNormal(normalize(cross(v2 - v0, v1 - v0)));
}

void CurvedWorld_ClassicRunner_Z_Negative(inout float4 inVertexOS, float3 pivotPoint, float2 bendSize, float2 bendOffset)
{
    float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	positionWS -= pivotPoint;

	float2 offset = min(float2(0, 0), positionWS.zz + bendOffset.xy);
	offset *= offset;
	positionWS = float3(-bendSize.y * offset.y, bendSize.x * offset.x, 0.0f) * 0.001;

	
	
	inVertexOS.xyz += CurvedWorld_WorldToObject(float4(positionWS, 0), 0);
}

void CurvedWorld_ClassicRunner_Z_Negative(inout float4 inVertexOS, inout float3 normalOS, float4 tangentOS, float3 pivotPoint, float2 bendSize, float2 bendOffset)
{
	float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	float3 normalWS   = CurvedWorld_ObjectToWorldNormal(normalOS);
	float3 tangentWS  = CurvedWorld_ObjectToWorldTangent(tangentOS.xyz);
	float3 binormalWS = cross(tangentWS, normalWS);


	float3 v0 = positionWS - pivotPoint;
	float3 v1 = v0 + tangentWS;
	float3 v2 = v0 + binormalWS;
 

	float2 offset = min(float2(0, 0), v0.zz + bendOffset.xy);
	offset *= offset;
	float3 transformedVertex = float3(-bendSize.y * offset.y, bendSize.x * offset.x, 0.0f) * 0.001;
	v0 += transformedVertex;
			

	offset = min(float2(0, 0), v1.zz + bendOffset.xy);
	offset *= offset;
	v1 += float3(-bendSize.y * offset.y, bendSize.x * offset.x, 0.0f) * 0.001; 

			
	offset = min(float2(0, 0), v2.zz + bendOffset.xy);
	offset *= offset;
	v2 += float3(-bendSize.y * offset.y, bendSize.x * offset.x, 0.0f) * 0.001; 


	
	inVertexOS.xyz += CurvedWorld_WorldToObject(float4(transformedVertex, 0), 0);

	normalOS = CurvedWorld_WorldToObjectNormal(normalize(cross(v2 - v0, v1 - v0)));
}

////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                              Little Planet                                 //
//                                                                            //
//////////////////////////////////////////////////////////////////////////////// 
void CurvedWorld_LittlePlanet_X(inout float4 inVertexOS, float3 pivotPoint, float bendSize, float bendOffset)
{
	float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	positionWS -= pivotPoint;

	float2 offset = max(float2(0, 0), abs(positionWS.yz) - bendOffset);
	offset *= step(float2(0, 0), positionWS.yz) * 2 - 1;
	offset *= offset;
	positionWS = float3(-(bendSize * offset.x + bendSize * offset.y) * 0.001, 0, 0); 



	inVertexOS.xyz += CurvedWorld_WorldToObject(float4(positionWS, 0), 0);	
}

void CurvedWorld_LittlePlanet_X(inout float4 inVertexOS, inout float3 normalOS, float4 tangentOS, float3 pivotPoint, float bendSize, float bendOffset)
{
	float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	float3 normalWS   = CurvedWorld_ObjectToWorldNormal(normalOS);
	float3 tangentWS  = CurvedWorld_ObjectToWorldTangent(tangentOS.xyz);
	float3 binormalWS = cross(tangentWS, normalWS);


	float3 v0 = positionWS - pivotPoint;
	float3 v1 = v0 + tangentWS;
	float3 v2 = v0 + binormalWS;
	 

	float2 offset = max(float2(0, 0), abs(v0.yz) - bendOffset);
	offset *= step(float2(0, 0), v0.yz) * 2 - 1;
	offset *= offset;
	float3 transformedVertex = float3(-(bendSize * offset.x + bendSize * offset.y) * 0.001, 0, 0); 
	v0 += transformedVertex;
					  
	  		
	offset = max(float2(0, 0), abs(v1.yz) - bendOffset);
	offset *= step(float2(0, 0), v1.yz) * 2 - 1;
	offset *= offset; 		
	v1.x += -(bendSize * offset.x + bendSize * offset.y) * 0.001;
				 
			
	offset = max(float2(0, 0), abs(v2.yz) - bendOffset);
	offset *= step(float2(0, 0), v2.yz) * 2 - 1;
	offset *= offset; 		
	v2.x += -(bendSize * offset.x + bendSize * offset.y) * 0.001;	



	inVertexOS.xyz += CurvedWorld_WorldToObject(float4(transformedVertex, 0), 0);

	normalOS = CurvedWorld_WorldToObjectNormal(normalize(cross(v2 - v0, v1 - v0)));
}

void CurvedWorld_LittlePlanet_Y(inout float4 inVertexOS, float3 pivotPoint, float bendSize, float bendOffset)
{
	float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	positionWS -= pivotPoint;

	float2 offset = max(float2(0, 0), abs(positionWS.xz) - bendOffset.xx);
	offset *= step(float2(0, 0), positionWS.xz) * 2 - 1;
	offset *= offset;
	positionWS = float3(0, -(bendSize.x * offset.x + bendSize.x * offset.y) * 0.001, 0); 


	inVertexOS.xyz += CurvedWorld_WorldToObject(float4(positionWS, 0), 0);	
}

void CurvedWorld_LittlePlanet_Y(inout float4 inVertexOS, inout float3 normalOS, float4 tangentOS, float3 pivotPoint, float bendSize, float bendOffset)
{
	float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	float3 normalWS   = CurvedWorld_ObjectToWorldNormal(normalOS);
	float3 tangentWS  = CurvedWorld_ObjectToWorldTangent(tangentOS.xyz);
	float3 binormalWS = cross(tangentWS, normalWS);


	float3 v0 = positionWS - pivotPoint;
	float3 v1 = v0 + tangentWS;
	float3 v2 = v0 + binormalWS;
	 

	float2 offset = max(float2(0, 0), abs(v0.xz) - bendOffset.xx);
	offset *= step(float2(0, 0), v0.xz) * 2 - 1;
	offset *= offset;
	float3 transformedVertex = float3(0, -(bendSize.x * offset.x + bendSize.x * offset.y) * 0.001, 0); 
	v0 += transformedVertex;
					  
	  		
	offset = max(float2(0, 0), abs(v1.xz) - bendOffset.xx);
	offset *= step(float2(0, 0), v1.xz) * 2 - 1;
	offset *= offset; 		
	v1.y += -(bendSize.x * offset.x + bendSize.x * offset.y) * 0.001;
				 
			
	offset = max(float2(0, 0), abs(v2.xz) - bendOffset.xx);
	offset *= step(float2(0, 0), v2.xz) * 2 - 1;
	offset *= offset; 		
	v2.y += -(bendSize.x * offset.x + bendSize.x * offset.y) * 0.001;	



	inVertexOS.xyz += CurvedWorld_WorldToObject(float4(transformedVertex, 0), 0);

	normalOS = CurvedWorld_WorldToObjectNormal(normalize(cross(v2 - v0, v1 - v0)));
}

void CurvedWorld_LittlePlanet_Z(inout float4 inVertexOS, float3 pivotPoint, float bendSize, float bendOffset)
{
	float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	positionWS -= pivotPoint;

	float2 offset = max(float2(0, 0), abs(positionWS.xy) - bendOffset.xx);
	offset *= step(float2(0, 0), positionWS.xy) * 2 - 1;
	offset *= offset;
	positionWS = float3(0, 0, -(bendSize.x * offset.x + bendSize.x * offset.y) * 0.001); 



	inVertexOS.xyz += CurvedWorld_WorldToObject(float4(positionWS, 0), 0);	
}

void CurvedWorld_LittlePlanet_Z(inout float4 inVertexOS, inout float3 normalOS, float4 tangentOS, float3 pivotPoint, float bendSize, float bendOffset)
{
	float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	float3 normalWS   = CurvedWorld_ObjectToWorldNormal(normalOS);
	float3 tangentWS  = CurvedWorld_ObjectToWorldTangent(tangentOS.xyz);
	float3 binormalWS = cross(tangentWS, normalWS);


	float3 v0 = positionWS - pivotPoint;
	float3 v1 = v0 + tangentWS;
	float3 v2 = v0 + binormalWS;
	 

	float2 offset = max(float2(0, 0), abs(v0.xy) - bendOffset.xx);
	offset *= step(float2(0, 0), v0.xy) * 2 - 1;
	offset *= offset;
	float3 transformedVertex = float3(0, 0, -(bendSize.x * offset.x + bendSize.x * offset.y) * 0.001); 
	v0 += transformedVertex;
					  
	  		
	offset = max(float2(0, 0), abs(v1.xy) - bendOffset.xx);
	offset *= step(float2(0, 0), v1.xy) * 2 - 1;
	offset *= offset; 		
	v1.z += -(bendSize.x * offset.x + bendSize.x * offset.y) * 0.001;
				 
			
	offset = max(float2(0, 0), abs(v2.xy) - bendOffset.xx);
	offset *= step(float2(0, 0), v2.xy) * 2 - 1;
	offset *= offset; 		
	v2.z += -(bendSize.x * offset.x + bendSize.x * offset.y) * 0.001;	



	inVertexOS.xyz += CurvedWorld_WorldToObject(float4(transformedVertex, 0), 0);

	normalOS = CurvedWorld_WorldToObjectNormal(normalize(cross(v2 - v0, v1 - v0)));
}

////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                            Cylindrical Tower                               //
//                                                                            //
//////////////////////////////////////////////////////////////////////////////// 
void CurvedWorld_CylindricalTower_X(inout float4 inVertexOS, float3 pivotPoint, float3 bendSize, float3 bendOffset)
{
    float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	positionWS -= pivotPoint;

	float2 offset = max(float2(0, 0), abs(positionWS.xy) - bendOffset.yy);
	offset *= step(float2(0, 0), positionWS.xy) * 2 - 1;
	offset *= offset;
	positionWS = float3(0, 0, bendSize.y * offset.x) * 0.001;

	
	
	inVertexOS.xyz += CurvedWorld_WorldToObject(float4(positionWS, 0), 0);
}

void CurvedWorld_CylindricalTower_X(inout float4 inVertexOS, inout float3 normalOS, float4 tangentOS, float3 pivotPoint, float3 bendSize, float3 bendOffset)
{
	float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	float3 normalWS   = CurvedWorld_ObjectToWorldNormal(normalOS);
	float3 tangentWS  = CurvedWorld_ObjectToWorldTangent(tangentOS.xyz);
	float3 binormalWS = cross(tangentWS, normalWS);


	float3 v0 = positionWS - pivotPoint;
	float3 v1 = v0 + tangentWS;
	float3 v2 = v0 + binormalWS;
 

	float2 offset = max(float2(0, 0), abs(v0.xy) - bendOffset.yy);
	offset *= step(float2(0, 0), v0.xy) * 2 - 1;
	offset *= offset;
	float3 transformedVertex = float3(0, 0, bendSize.y * offset.x * 0.001); 
	v0 += transformedVertex;
						
				
	offset = max(float2(0, 0), abs(v1.xy) - bendOffset.yy);
	offset *= step(float2(0, 0), v1.xy) * 2 - 1;
	offset *= offset; 		
	v1.z += bendSize.y * offset.x * 0.001;
					
				
	offset = max(float2(0, 0), abs(v2.xy) - bendOffset.yy);
	offset *= step(float2(0, 0), v2.xy) * 2 - 1;
	offset *= offset; 		
	v2.z += bendSize.y * offset.x * 0.001;	


	
	inVertexOS.xyz += CurvedWorld_WorldToObject(float4(transformedVertex, 0), 0);

	normalOS = CurvedWorld_WorldToObjectNormal(normalize(cross(v2 - v0, v1 - v0)));
}

void CurvedWorld_CylindricalTower_Z(inout float4 inVertexOS, float3 pivotPoint, float3 bendSize, float3 bendOffset)
{
    float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	positionWS -= pivotPoint;

	float2 offset = max(float2(0, 0), abs(positionWS.zy) - bendOffset.yy);
	offset *= step(float2(0, 0), positionWS.zy) * 2 - 1;
	offset *= offset;
	positionWS = float3(bendSize.y * offset.x, 0, 0) * 0.001;

	
	
	inVertexOS.xyz += CurvedWorld_WorldToObject(float4(positionWS, 0), 0);
}

void CurvedWorld_CylindricalTower_Z(inout float4 inVertexOS, inout float3 normalOS, float4 tangentOS, float3 pivotPoint, float3 bendSize, float3 bendOffset)
{
	float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	float3 normalWS   = CurvedWorld_ObjectToWorldNormal(normalOS);
	float3 tangentWS  = CurvedWorld_ObjectToWorldTangent(tangentOS.xyz);
	float3 binormalWS = cross(tangentWS, normalWS);


	float3 v0 = positionWS - pivotPoint;
	float3 v1 = v0 + tangentWS;
	float3 v2 = v0 + binormalWS;
 

	float2 offset = max(float2(0, 0), abs(v0.zy) - bendOffset.yy);
	offset *= step(float2(0, 0), v0.zy) * 2 - 1;
	offset *= offset;
	float3 transformedVertex = float3(bendSize.y * offset.x * 0.001, 0, 0); 
	v0 += transformedVertex;
						
				
	offset = max(float2(0, 0), abs(v1.zy) - bendOffset.yy);
	offset *= step(float2(0, 0), v1.zy) * 2 - 1;
	offset *= offset; 		
	v1.x += bendSize.y * offset.x * 0.001;
					
				
	offset = max(float2(0, 0), abs(v2.zy) - bendOffset.yy);
	offset *= step(float2(0, 0), v2.zy) * 2 - 1;
	offset *= offset; 		
	v2.x += bendSize.y * offset.x * 0.001;	


	
	inVertexOS.xyz += CurvedWorld_WorldToObject(float4(transformedVertex, 0), 0);

	normalOS = CurvedWorld_WorldToObjectNormal(normalize(cross(v2 - v0, v1 - v0)));
}

////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                           Cylindrical Rolloff                              //
//                                                                            //
//////////////////////////////////////////////////////////////////////////////// 
void CurvedWorld_CylindricalRolloff_X(inout float4 inVertexOS, float3 pivotPoint, float3 bendSize, float3 bendOffset)
{
    float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	positionWS -= pivotPoint;

	float2 offset = max(float2(0, 0), abs(positionWS.zx) - bendOffset.xx);
	offset *= step(float2(0, 0), positionWS.zx) * 2 - 1;
	offset *= offset;
	positionWS = float3(0, -bendSize.x * offset.y, 0) * 0.001;

	
	
	inVertexOS.xyz += CurvedWorld_WorldToObject(float4(positionWS, 0), 0);
}

void CurvedWorld_CylindricalRolloff_X(inout float4 inVertexOS, inout float3 normalOS, float4 tangentOS, float3 pivotPoint, float3 bendSize, float3 bendOffset)
{
	float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	float3 normalWS   = CurvedWorld_ObjectToWorldNormal(normalOS);
	float3 tangentWS  = CurvedWorld_ObjectToWorldTangent(tangentOS.xyz);
	float3 binormalWS = cross(tangentWS, normalWS);


	float3 v0 = positionWS - pivotPoint;
	float3 v1 = v0 + tangentWS;
	float3 v2 = v0 + binormalWS;
 

	float2 offset = max(float2(0, 0), abs(v0.zx) - bendOffset.xx);
	offset *= step(float2(0, 0), v0.zx) * 2 - 1;
	offset *= offset;
	float3 transformedVertex = float3(0, -(bendSize.x * offset.y) * 0.001, 0.0f); 
	v0 += transformedVertex;
						
				
	offset = max(float2(0, 0), abs(v1.zx) - bendOffset.xx);
	offset *= step(float2(0, 0), v1.zx) * 2 - 1;
	offset *= offset; 		
	v1.y += -(bendSize.x * offset.y) * 0.001;
					
				
	offset = max(float2(0, 0), abs(v2.zx) - bendOffset.xx);
	offset *= step(float2(0, 0), v2.zx) * 2 - 1;
	offset *= offset; 		
	v2.y += -(bendSize.x * offset.y) * 0.001;	


	
	inVertexOS.xyz += CurvedWorld_WorldToObject(float4(transformedVertex, 0), 0);

	normalOS = CurvedWorld_WorldToObjectNormal(normalize(cross(v2 - v0, v1 - v0)));
}

void CurvedWorld_CylindricalRolloff_Z(inout float4 inVertexOS, float3 pivotPoint, float3 bendSize, float3 bendOffset)
{
    float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	positionWS -= pivotPoint;

	float2 offset = max(float2(0, 0), abs(positionWS.zx) - bendOffset.xx);
	offset *= step(float2(0, 0), positionWS.zx) * 2 - 1;
	offset *= offset;
	positionWS = float3(0, -bendSize.x * offset.x, 0) * 0.001;

	
	
	inVertexOS.xyz += CurvedWorld_WorldToObject(float4(positionWS, 0), 0);
}

void CurvedWorld_CylindricalRolloff_Z(inout float4 inVertexOS, inout float3 normalOS, float4 tangentOS, float3 pivotPoint, float3 bendSize, float3 bendOffset)
{
	float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	float3 normalWS   = CurvedWorld_ObjectToWorldNormal(normalOS);
	float3 tangentWS  = CurvedWorld_ObjectToWorldTangent(tangentOS.xyz);
	float3 binormalWS = cross(tangentWS, normalWS);


	float3 v0 = positionWS - pivotPoint;
	float3 v1 = v0 + tangentWS;
	float3 v2 = v0 + binormalWS;
 

	float2 offset = max(float2(0, 0), abs(v0.zx) - bendOffset.xx);
	offset *= step(float2(0, 0), v0.zx) * 2 - 1;
	offset *= offset;
	float3 transformedVertex = float3(0, -(bendSize.x * offset.x) * 0.001, 0.0f); 
	v0 += transformedVertex;
						
				
	offset = max(float2(0, 0), abs(v1.zx) - bendOffset.xx);
	offset *= step(float2(0, 0), v1.zx) * 2 - 1;
	offset *= offset; 		
	v1.y += -(bendSize.x * offset.x) * 0.001;
					
				
	offset = max(float2(0, 0), abs(v2.zx) - bendOffset.xx);
	offset *= step(float2(0, 0), v2.zx) * 2 - 1;
	offset *= offset; 		
	v2.y += -(bendSize.x * offset.x) * 0.001;


	
	inVertexOS.xyz += CurvedWorld_WorldToObject(float4(transformedVertex, 0), 0);

	normalOS = CurvedWorld_WorldToObjectNormal(normalize(cross(v2 - v0, v1 - v0)));
}

////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                            Spiral Horizontal                               //
//                                                                            //
//////////////////////////////////////////////////////////////////////////////// 
void CurvedWorld_SpiralHorizontal_X_Positive(inout float4 inVertexOS, float3 pivotPoint, float3 rotationCenter, float bendAngle, float bendMinimumlRadius)
{
    float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	

	positionWS -= pivotPoint;
	rotationCenter -= pivotPoint;

	if(positionWS.x > rotationCenter.x)
	{
		rotationCenter.z = abs(rotationCenter.z) < bendMinimumlRadius.x ? bendMinimumlRadius.x * CurvedWorld_Sign(rotationCenter.z) : rotationCenter.z;
		float radius = rotationCenter.z;

		float angle = bendAngle.x * CurvedWorld_Sign(radius);
		float l = 6.28318530717 * radius * (angle / 360);

		float absX = abs(rotationCenter.x - positionWS.x) / l;
		float smoothAbsX = CurvedWorld_Smooth(absX);


		Spiral_H_Rotate_X_Negative(positionWS, rotationCenter, absX, smoothAbsX, l, angle);		
	}
 
	
	positionWS += pivotPoint;
	
	inVertexOS.xyz = CurvedWorld_WorldToObject(float4(positionWS, 1), 1);
}
 
void CurvedWorld_SpiralHorizontal_X_Positive(inout float4 inVertexOS, inout float3 normalOS, float4 tangentOS, float3 pivotPoint, float3 rotationCenter, float bendAngle, float bendMinimumlRadius)
{
	float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	float3 normalWS   = CurvedWorld_ObjectToWorldNormal(normalOS);
	float3 tangentWS  = CurvedWorld_ObjectToWorldTangent(tangentOS.xyz);
	float3 binormalWS = cross(tangentWS, normalWS);


	positionWS -= pivotPoint;
	rotationCenter -= pivotPoint;

	float3 v0 = positionWS;
	float3 v1 = v0 + tangentWS;
	float3 v2 = v0 + binormalWS;
	 

	rotationCenter.z = abs(rotationCenter.z) < bendMinimumlRadius.x ? bendMinimumlRadius.x * CurvedWorld_Sign(rotationCenter.z) : rotationCenter.z;
	float radius = rotationCenter.z;

	float angle = bendAngle.x * CurvedWorld_Sign(radius);
	float l = 6.28318530717 * radius * (angle / 360);

	float3 absX = abs(rotationCenter.xxx - float3(v0.x, v1.x, v2.x)) / l;
	float3 smoothAbsX = CurvedWorld_Smooth(absX);


	if(v0.x > rotationCenter.x)
	{
		Spiral_H_Rotate_X_Negative(v0, rotationCenter, absX.x, smoothAbsX.x, l, angle);
	}
	if(v1.x > rotationCenter.x)
	{
		Spiral_H_Rotate_X_Negative(v1, rotationCenter, absX.y, smoothAbsX.y, l, angle);
	}
	if(v2.x > rotationCenter.x)
	{
		Spiral_H_Rotate_X_Negative(v2, rotationCenter, absX.z, smoothAbsX.z, l, angle);
	}


	v0 += pivotPoint;
	v1 += pivotPoint;
	v2 += pivotPoint;

	inVertexOS.xyz = CurvedWorld_WorldToObject(float4(v0, 1), 1);

	normalOS = CurvedWorld_WorldToObjectNormal(normalize(cross(v2 - v0, v1 - v0)));
}

void CurvedWorld_SpiralHorizontal_X_Negative(inout float4 inVertexOS, float3 pivotPoint, float3 rotationCenter, float bendAngle, float bendMinimumlRadius)
{
    float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	
	
	positionWS -= pivotPoint;
	rotationCenter -= pivotPoint;

	if(positionWS.x < rotationCenter.x)
	{
		rotationCenter.z = abs(rotationCenter.z) < bendMinimumlRadius.x ? bendMinimumlRadius.x * CurvedWorld_Sign(rotationCenter.z) : rotationCenter.z;
		float radius = rotationCenter.z;

		float angle = bendAngle.x * CurvedWorld_Sign(radius);
		float l = 6.28318530717 * radius * (angle / 360);

		float absX = abs(rotationCenter.x - positionWS.x) / l;
		float smoothAbsX = CurvedWorld_Smooth(absX);


		Spiral_H_Rotate_X_Positive(positionWS, rotationCenter, absX, smoothAbsX, l, angle);		
	}


	positionWS += pivotPoint;
	
	inVertexOS.xyz = CurvedWorld_WorldToObject(float4(positionWS, 1), 1);
}
 
void CurvedWorld_SpiralHorizontal_X_Negative(inout float4 inVertexOS, inout float3 normalOS, float4 tangentOS, float3 pivotPoint, float3 rotationCenter, float bendAngle, float bendMinimumlRadius)
{
	float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	float3 normalWS   = CurvedWorld_ObjectToWorldNormal(normalOS);
	float3 tangentWS  = CurvedWorld_ObjectToWorldTangent(tangentOS.xyz);
	float3 binormalWS = cross(tangentWS, normalWS);


	positionWS -= pivotPoint;
	rotationCenter -= pivotPoint;

	float3 v0 = positionWS;
	float3 v1 = v0 + tangentWS;
	float3 v2 = v0 + binormalWS;
	 

	rotationCenter.z = abs(rotationCenter.z) < bendMinimumlRadius.x ? bendMinimumlRadius.x * CurvedWorld_Sign(rotationCenter.z) : rotationCenter.z;
	float radius = rotationCenter.z;

	float angle = bendAngle.x * CurvedWorld_Sign(radius);
	float l = 6.28318530717 * radius * (angle / 360);

	float3 absX = abs(rotationCenter.xxx - float3(v0.x, v1.x, v2.x)) / l;
	float3 smoothAbsX = CurvedWorld_Smooth(absX);

	if(v0.x < rotationCenter.x)
	{
		Spiral_H_Rotate_X_Positive(v0, rotationCenter, absX.x, smoothAbsX.x, l, angle);
	}
	if(v1.x < rotationCenter.x)
	{
		Spiral_H_Rotate_X_Positive(v1, rotationCenter, absX.y, smoothAbsX.y, l, angle);
	}
	if(v2.x < rotationCenter.x)
	{
		Spiral_H_Rotate_X_Positive(v2, rotationCenter, absX.z, smoothAbsX.z, l, angle);
	}


	v0 += pivotPoint;
	v1 += pivotPoint;
	v2 += pivotPoint;

	inVertexOS.xyz = CurvedWorld_WorldToObject(float4(v0, 1), 1);

	normalOS = CurvedWorld_WorldToObjectNormal(normalize(cross(v2 - v0, v1 - v0)));
}

void CurvedWorld_SpiralHorizontal_Z_Positive(inout float4 inVertexOS, float3 pivotPoint, float3 rotationCenter, float bendAngle, float bendMinimumlRadius)
{
    float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	

	positionWS -= pivotPoint;
	rotationCenter -= pivotPoint;

	if(positionWS.z > rotationCenter.z)
	{
		rotationCenter.x = abs(rotationCenter.x) < bendMinimumlRadius.x ? bendMinimumlRadius.x * CurvedWorld_Sign(rotationCenter.x) : rotationCenter.x;
		float radius = rotationCenter.x;

		float angle = bendAngle.x * CurvedWorld_Sign(radius);
		float l = 6.28318530717 * radius * (angle / 360);

		float absZ = abs(rotationCenter.z - positionWS.z) / l;
		float smoothAbsZ = CurvedWorld_Smooth(absZ);


		Spiral_H_Rotate_Z_Positive(positionWS, rotationCenter, absZ, smoothAbsZ, l, angle);
	}

	
	positionWS += pivotPoint;
	
	inVertexOS.xyz = CurvedWorld_WorldToObject(float4(positionWS, 1), 1);
}
 
void CurvedWorld_SpiralHorizontal_Z_Positive(inout float4 inVertexOS, inout float3 normalOS, float4 tangentOS, float3 pivotPoint, float3 rotationCenter, float bendAngle, float bendMinimumlRadius)
{
	float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	float3 normalWS   = CurvedWorld_ObjectToWorldNormal(normalOS);
	float3 tangentWS  = CurvedWorld_ObjectToWorldTangent(tangentOS.xyz);
	float3 binormalWS = cross(tangentWS, normalWS);
 

	positionWS -= pivotPoint;
	rotationCenter -= pivotPoint;

	float3 v0 = positionWS;
	float3 v1 = v0 + tangentWS;
	float3 v2 = v0 + binormalWS;
	 

	rotationCenter.x = abs(rotationCenter.x) < bendMinimumlRadius.x ? bendMinimumlRadius.x * CurvedWorld_Sign(rotationCenter.x) : rotationCenter.x;
	float radius = rotationCenter.x;

	float angle = bendAngle.x * CurvedWorld_Sign(radius);
	float l = 6.28318530717 * radius * (angle / 360);

	float3 absZ = abs(rotationCenter.zzz - float3(v0.z, v1.z, v2.z)) / l;
	float3 smoothAbsZ = CurvedWorld_Smooth(absZ);


	if(v0.z > rotationCenter.z)
	{
		Spiral_H_Rotate_Z_Positive(v0, rotationCenter, absZ.x, smoothAbsZ.x, l, angle);
	}
	if(v1.z > rotationCenter.z)
	{
		Spiral_H_Rotate_Z_Positive(v1, rotationCenter, absZ.y, smoothAbsZ.y, l, angle);
	}
	if(v2.z > rotationCenter.z)
	{
		Spiral_H_Rotate_Z_Positive(v2, rotationCenter, absZ.z, smoothAbsZ.z, l, angle);
	}


	v0 += pivotPoint;
	v1 += pivotPoint;
	v2 += pivotPoint;

	inVertexOS.xyz = CurvedWorld_WorldToObject(float4(v0, 1), 1);

	normalOS = CurvedWorld_WorldToObjectNormal(normalize(cross(v2 - v0, v1 - v0)));
}

void CurvedWorld_SpiralHorizontal_Z_Negative(inout float4 inVertexOS, float3 pivotPoint, float3 rotationCenter, float bendAngle, float bendMinimumlRadius)
{
    float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	

	positionWS -= pivotPoint;
	rotationCenter -= pivotPoint;

	if(positionWS.z < rotationCenter.z)
	{
		rotationCenter.x = abs(rotationCenter.x) < bendMinimumlRadius.x ? bendMinimumlRadius.x * CurvedWorld_Sign(rotationCenter.x) : rotationCenter.x;
		float radius = rotationCenter.x;

		float angle = bendAngle.x * CurvedWorld_Sign(radius);
		float l = 6.28318530717 * radius * (angle / 360);

		float absZ = abs(rotationCenter.z - positionWS.z) / l;
		float smoothAbsZ = CurvedWorld_Smooth(absZ);


		Spiral_H_Rotate_Z_Negative(positionWS, rotationCenter, absZ, smoothAbsZ, l, angle);		
	}

	
	positionWS += pivotPoint;
	
	inVertexOS.xyz = CurvedWorld_WorldToObject(float4(positionWS, 1), 1);
}
	
void CurvedWorld_SpiralHorizontal_Z_Negative(inout float4 inVertexOS, inout float3 normalOS, float4 tangentOS, float3 pivotPoint, float3 rotationCenter, float bendAngle, float bendMinimumlRadius)
{
	float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	float3 normalWS   = CurvedWorld_ObjectToWorldNormal(normalOS);
	float3 tangentWS  = CurvedWorld_ObjectToWorldTangent(tangentOS.xyz);
	float3 binormalWS = cross(tangentWS, normalWS);


	positionWS -= pivotPoint;
	rotationCenter -= pivotPoint;

	float3 v0 = positionWS;
	float3 v1 = v0 + tangentWS;
	float3 v2 = v0 + binormalWS;
	 

	rotationCenter.x = abs(rotationCenter.x) < bendMinimumlRadius.x ? bendMinimumlRadius.x * CurvedWorld_Sign(rotationCenter.x) : rotationCenter.x;
	float radius = rotationCenter.x;

	float angle = bendAngle.x * CurvedWorld_Sign(radius);
	float l = 6.28318530717 * radius * (angle / 360);

	float3 absZ = abs(rotationCenter.zzz - float3(v0.z, v1.z, v2.z)) / l;
	float3 smoothAbsZ = CurvedWorld_Smooth(absZ);


	if(v0.z < rotationCenter.z)
	{
		Spiral_H_Rotate_Z_Negative(v0, rotationCenter, absZ.x, smoothAbsZ.x, l, angle);
	}
	if(v1.z < rotationCenter.z)
	{
		Spiral_H_Rotate_Z_Negative(v1, rotationCenter, absZ.y, smoothAbsZ.y, l, angle);
	}
	if(v2.z < rotationCenter.z)
	{
		Spiral_H_Rotate_Z_Negative(v2, rotationCenter, absZ.z, smoothAbsZ.z, l, angle);
	}


	v0 += pivotPoint;
	v1 += pivotPoint;
	v2 += pivotPoint;

	inVertexOS.xyz = CurvedWorld_WorldToObject(float4(v0, 1), 1);

	normalOS = CurvedWorld_WorldToObjectNormal(normalize(cross(v2 - v0, v1 - v0)));
}

////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                        Spiral Horizontal Double                            //
//                                                                            //
//////////////////////////////////////////////////////////////////////////////// 
void CurvedWorld_SpiralHorizontalDouble_X(inout float4 inVertexOS, float3 pivotPoint, float3 rotationCenter, float3 rotationCenter2, float2 bendAngle, float2 bendMinimumlRadius)
{
    float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	

	positionWS -= pivotPoint;
	rotationCenter -= pivotPoint;
	rotationCenter2 -= pivotPoint;

	float2 p = float2(rotationCenter.z, rotationCenter2.z);
	float2 radius = abs(p) < bendMinimumlRadius ? bendMinimumlRadius * CurvedWorld_Sign(p) : p;
				

	float2 angle = bendAngle * CurvedWorld_Sign(radius);
	float2 l = 6.28318530717 * radius * (angle / 360);

	float2 absX = abs(float2(rotationCenter.x, rotationCenter2.x) - positionWS.xx) / l;
	float2 smoothAbsX = CurvedWorld_Smooth(absX);


	if(positionWS.x < rotationCenter.x)
	{
		rotationCenter.z = radius.x;
		Spiral_H_Rotate_X_Positive(positionWS, rotationCenter, absX.x, smoothAbsX.x, l.x, angle.x);
	}
	else if(positionWS.x.x > rotationCenter2.x)
	{
		rotationCenter2.z = radius.y;
		Spiral_H_Rotate_X_Negative(positionWS, rotationCenter2, absX.y, smoothAbsX.y, l.y, angle.y);
	}

	
	positionWS += pivotPoint;
	
	inVertexOS.xyz = CurvedWorld_WorldToObject(float4(positionWS, 1), 1);
}
 
void CurvedWorld_SpiralHorizontalDouble_X(inout float4 inVertexOS, inout float3 normalOS, float4 tangentOS, float3 pivotPoint, float3 rotationCenter, float3 rotationCenter2, float2 bendAngle, float2 bendMinimumlRadius)
{
	float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	float3 normalWS   = CurvedWorld_ObjectToWorldNormal(normalOS);
	float3 tangentWS  = CurvedWorld_ObjectToWorldTangent(tangentOS.xyz);
	float3 binormalWS = cross(tangentWS, normalWS);


	positionWS -= pivotPoint;
	rotationCenter -= pivotPoint;
	rotationCenter2 -= pivotPoint;

	float3 v0 = positionWS;
	float3 v1 = v0 + tangentWS;
	float3 v2 = v0 + binormalWS;
	 

	float2 p = float2(rotationCenter.z, rotationCenter2.z);
	float2 radius = abs(p) < bendMinimumlRadius ? bendMinimumlRadius * CurvedWorld_Sign(p) : p;
		
	float2 angle = bendAngle * CurvedWorld_Sign(radius);
	float2 l = 6.28318530717 * radius * (angle / 360);
		

	float3 absX = abs(rotationCenter.xxx - float3(v0.x, v1.x, v2.x)) / l.x;
	float3 smoothAbsX = CurvedWorld_Smooth(absX);

	float3 absX_2 = abs(rotationCenter2.xxx - float3(v0.x, v1.x, v2.x)) / l.y;
	float3 smoothAbsX_2 = CurvedWorld_Smooth(absX_2);


	if(v0.x < rotationCenter.x)
	{
		rotationCenter.z = radius.x;
		Spiral_H_Rotate_X_Positive(v0, rotationCenter, absX.x, smoothAbsX.x, l.x, angle.x);
	}
	else if(v0.x > rotationCenter2.x)
	{
		rotationCenter2.z = radius.y;
		Spiral_H_Rotate_X_Negative(v0,  rotationCenter2, absX_2.x, smoothAbsX_2.x, l.y, angle.y);
	}

	if(v1.x < rotationCenter.x)
	{
		rotationCenter.z = radius.x;
		Spiral_H_Rotate_X_Positive(v1, rotationCenter, absX.y, smoothAbsX.y, l.x, angle.x);
	}
	else if(v1.x >  rotationCenter2.x)
	{
		rotationCenter2.z = radius.y;
		Spiral_H_Rotate_X_Negative(v1,  rotationCenter2, absX_2.y, smoothAbsX_2.y, l.y, angle.y);
	}

	if(v2.x < rotationCenter.x)
	{
		rotationCenter.z = radius.x;
		Spiral_H_Rotate_X_Positive(v2, rotationCenter, absX.z, smoothAbsX.z, l.x, angle.x);
	}
	else if(v2.x >  rotationCenter2.x)
	{
		rotationCenter2.z = radius.y;
		Spiral_H_Rotate_X_Negative(v2,  rotationCenter2, absX_2.z, smoothAbsX_2.z, l.y, angle.y);
	}


	v0 += pivotPoint;
	v1 += pivotPoint;
	v2 += pivotPoint;

	inVertexOS.xyz = CurvedWorld_WorldToObject(float4(v0, 1), 1);

	normalOS = CurvedWorld_WorldToObjectNormal(normalize(cross(v2 - v0, v1 - v0)));
}

void CurvedWorld_SpiralHorizontalDouble_Z(inout float4 inVertexOS, float3 pivotPoint, float3 rotationCenter, float3 rotationCenter2, float2 bendAngle, float2 bendMinimumlRadius)
{
    float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	

	positionWS -= pivotPoint;
	rotationCenter -= pivotPoint;
	rotationCenter2 -= pivotPoint;

	float2 p = float2(rotationCenter.x, rotationCenter2.x);
	float2 radius = abs(p) < bendMinimumlRadius ? bendMinimumlRadius * CurvedWorld_Sign(p) : p;

	float2 angle = bendAngle * CurvedWorld_Sign(radius);
	float2 l = 6.28318530717 * radius * (angle / 360);

	float2 absZ = abs(float2(rotationCenter.z, rotationCenter2.z) - positionWS.zz) / l;
	float2 smoothAbsZ = CurvedWorld_Smooth(absZ);


	if(positionWS.z < rotationCenter.z)
	{
		rotationCenter.x = radius.x;
		Spiral_H_Rotate_Z_Negative(positionWS, rotationCenter, absZ.x, smoothAbsZ.x, l.x, angle.x);
	}
	else if(positionWS.z > rotationCenter2.z)
	{			
		rotationCenter2.x = radius.y;
		Spiral_H_Rotate_Z_Positive(positionWS, rotationCenter2, absZ.y, smoothAbsZ.y, l.y, angle.y);
	}

	
	positionWS += pivotPoint;

	inVertexOS.xyz = CurvedWorld_WorldToObject(float4(positionWS, 1), 1);
}
 
void CurvedWorld_SpiralHorizontalDouble_Z(inout float4 inVertexOS, inout float3 normalOS, float4 tangentOS, float3 pivotPoint, float3 rotationCenter, float3 rotationCenter2, float2 bendAngle, float2 bendMinimumlRadius)
{
	float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	float3 normalWS   = CurvedWorld_ObjectToWorldNormal(normalOS);
	float3 tangentWS  = CurvedWorld_ObjectToWorldTangent(tangentOS.xyz);
	float3 binormalWS = cross(tangentWS, normalWS);


	positionWS -= pivotPoint;
	rotationCenter -= pivotPoint;
	rotationCenter2 -= pivotPoint;


	float3 v0 = positionWS;
	float3 v1 = v0 + tangentWS;
	float3 v2 = v0 + binormalWS;
	 

	float2 p = float2(rotationCenter.x, rotationCenter2.x);
	float2 radius = abs(p) < bendMinimumlRadius ? bendMinimumlRadius * CurvedWorld_Sign(p) : p;
			
	float2 angle = bendAngle * CurvedWorld_Sign(radius);
	float2 l = 6.28318530717 * radius * (angle / 360);


	float3 absZ = abs(rotationCenter.zzz - float3(v0.z, v1.z, v2.z)) / l.x;
	float3 smoothAbsZ = CurvedWorld_Smooth(absZ);

	float3 absZ_2 = abs(rotationCenter2.zzz - float3(v0.z, v1.z, v2.z)) / l.y;
	float3 smoothAbsZ_2 = CurvedWorld_Smooth(absZ_2);


	if(v0.z < rotationCenter.z)
	{
		rotationCenter.x = radius.x;
		Spiral_H_Rotate_Z_Negative(v0, rotationCenter, absZ.x, smoothAbsZ.x, l.x, angle.x);
	}
	else if(v0.z > rotationCenter2.z)
	{
		rotationCenter2.x = radius.y;
		Spiral_H_Rotate_Z_Positive(v0, rotationCenter2, absZ_2.x, smoothAbsZ_2.x, l.y, angle.y);
	}

	if(v1.z < rotationCenter.z)
	{
		rotationCenter.x = radius.x;
		Spiral_H_Rotate_Z_Negative(v1, rotationCenter, absZ.y, smoothAbsZ.y, l.x, angle.x);
	}
	else if(v1.z > rotationCenter2.z)
	{
		rotationCenter2.x = radius.y;
		Spiral_H_Rotate_Z_Positive(v1, rotationCenter2, absZ_2.y, smoothAbsZ_2.y, l.y, angle.y);
	}

	if(v2.z < rotationCenter.z)
	{
		rotationCenter.x = radius.x;
		Spiral_H_Rotate_Z_Negative(v2, rotationCenter, absZ.z, smoothAbsZ.z, l.x, angle.x);
	} 
	else if(v2.z > rotationCenter2.z)
	{
		rotationCenter2.x = radius.y;
		Spiral_H_Rotate_Z_Positive(v2, rotationCenter2, absZ_2.z, smoothAbsZ_2.z, l.y, angle.y);
	}


	v0 += pivotPoint;
	v1 += pivotPoint;
	v2 += pivotPoint;

	inVertexOS.xyz = CurvedWorld_WorldToObject(float4(v0, 1), 1);

	normalOS = CurvedWorld_WorldToObjectNormal(normalize(cross(v2 - v0, v1 - v0)));
}

////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                        Spiral Horizontal Rolloff                           //
//                                                                            //
//////////////////////////////////////////////////////////////////////////////// 
void CurvedWorld_SpiralHorizontalRolloff_X(inout float4 inVertexOS, float3 pivotPoint, float3 rotationCenter, float bendAngle, float bendMinimumlRadius, float rolloff)
{
    float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	

	positionWS -= pivotPoint;
	rotationCenter -= pivotPoint;

	float3 rotationCenter2 = float3(rotationCenter.x + rolloff, rotationCenter.yz);

	rotationCenter.x -= rolloff;
	

	float radius = abs(rotationCenter.z) < bendMinimumlRadius.x ? bendMinimumlRadius.x * CurvedWorld_Sign(rotationCenter.z) : rotationCenter.z;	
	float angle = bendAngle.x * CurvedWorld_Sign(radius);
	float l = 6.28318530717 * radius * (angle / 360);

	float2 absX = abs(float2(rotationCenter.x, rotationCenter2.x) - positionWS.xx) / l;
	float2 smoothAbsX = CurvedWorld_Smooth(absX);


	if(positionWS.x < rotationCenter.x)
	{
		rotationCenter.z = radius;
		Spiral_H_Rotate_X_Positive(positionWS, rotationCenter, absX.x, smoothAbsX.x, l, angle);
	}
	else if(positionWS.x.x > rotationCenter2.x)
	{
		rotationCenter2.z = radius;
		Spiral_H_Rotate_X_Negative(positionWS, rotationCenter2, absX.y, smoothAbsX.y, l, angle);
	}


	positionWS += pivotPoint;
	
	inVertexOS.xyz = CurvedWorld_WorldToObject(float4(positionWS, 1), 1);
}
 
void CurvedWorld_SpiralHorizontalRolloff_X(inout float4 inVertexOS, inout float3 normalOS, float4 tangentOS, float3 pivotPoint, float3 rotationCenter, float bendAngle, float bendMinimumlRadius, float rolloff)
{
	float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	float3 normalWS   = CurvedWorld_ObjectToWorldNormal(normalOS);
	float3 tangentWS  = CurvedWorld_ObjectToWorldTangent(tangentOS.xyz);
	float3 binormalWS = cross(tangentWS, normalWS);


	positionWS -= pivotPoint;
	rotationCenter -= pivotPoint;

	float3 v0 = positionWS;
	float3 v1 = v0 + tangentWS;
	float3 v2 = v0 + binormalWS;
	 

	float3 rotationCenter2 = float3(rotationCenter.x + rolloff, rotationCenter.yz);	

	rotationCenter.x -= rolloff;
		

	float radius = abs(rotationCenter.z) < bendMinimumlRadius.x ? bendMinimumlRadius.x * CurvedWorld_Sign(rotationCenter.z) : rotationCenter.z;
		
	float angle = bendAngle.x * CurvedWorld_Sign(radius);
	float l = 6.28318530717 * radius * (angle / 360);
		

	float3 absX = abs(rotationCenter.xxx - float3(v0.x, v1.x, v2.x)) / l;
	float3 smoothAbsX = CurvedWorld_Smooth(absX);

	float3 absX_2 = abs(rotationCenter2.xxx - float3(v0.x, v1.x, v2.x)) / l;
	float3 smoothAbsX_2 = CurvedWorld_Smooth(absX_2);


	if(v0.x < rotationCenter.x)
	{
		rotationCenter.z = radius;
		Spiral_H_Rotate_X_Positive(v0, rotationCenter, absX.x, smoothAbsX.x, l, angle);
	}
	else if(v0.x > rotationCenter2.x)
	{
		rotationCenter2.z = radius;
		Spiral_H_Rotate_X_Negative(v0,  rotationCenter2, absX_2.x, smoothAbsX_2.x, l, angle);
	}

	if(v1.x < rotationCenter.x)
	{
		rotationCenter.z = radius;
		Spiral_H_Rotate_X_Positive(v1, rotationCenter, absX.y, smoothAbsX.y, l, angle);
	}
	else if(v1.x >  rotationCenter2.x)
	{
		rotationCenter2.z = radius;
		Spiral_H_Rotate_X_Negative(v1,  rotationCenter2, absX_2.y, smoothAbsX_2.y, l, angle);
	}

	if(v2.x < rotationCenter.x)
	{
		rotationCenter.z = radius;
		Spiral_H_Rotate_X_Positive(v2, rotationCenter, absX.z, smoothAbsX.z, l, angle);
	}
	else if(v2.x >  rotationCenter2.x)
	{
		rotationCenter2.z = radius;
		Spiral_H_Rotate_X_Negative(v2,  rotationCenter2, absX_2.z, smoothAbsX_2.z, l, angle);
	}


	v0 += pivotPoint;
	v1 += pivotPoint;
	v2 += pivotPoint;

	inVertexOS.xyz = CurvedWorld_WorldToObject(float4(v0, 1), 1);

	normalOS = CurvedWorld_WorldToObjectNormal(normalize(cross(v2 - v0, v1 - v0)));
}

void CurvedWorld_SpiralHorizontalRolloff_Z(inout float4 inVertexOS, float3 pivotPoint, float3 rotationCenter, float bendAngle, float bendMinimumlRadius, float rolloff)
{
    float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	

	positionWS -= pivotPoint;
	rotationCenter -= pivotPoint;

	float3 rotationCenter2 = float3(rotationCenter.xy, rotationCenter.z + rolloff);	

	rotationCenter.z -= rolloff;


	float radius = abs(rotationCenter.x) < bendMinimumlRadius.x ? bendMinimumlRadius.x * CurvedWorld_Sign(rotationCenter.x) : rotationCenter.x;

	float angle = bendAngle.x * CurvedWorld_Sign(radius);
	float l = 6.28318530717 * radius * (angle / 360);

	float2 absZ = abs(float2(rotationCenter.z, rotationCenter2.z) - positionWS.zz) / l;
	float2 smoothAbsZ = CurvedWorld_Smooth(absZ);


	if(positionWS.z < rotationCenter.z)
	{
		rotationCenter.x = radius;
		Spiral_H_Rotate_Z_Negative(positionWS, rotationCenter, absZ.x, smoothAbsZ.x, l, angle);
	}
	else if(positionWS.z > rotationCenter2.z)
	{			
		rotationCenter2.x = radius;
		Spiral_H_Rotate_Z_Positive(positionWS, rotationCenter2, absZ.y, smoothAbsZ.y, l, angle);
	}

	
	positionWS += pivotPoint;
	
	inVertexOS.xyz = CurvedWorld_WorldToObject(float4(positionWS, 1), 1);
}
 
void CurvedWorld_SpiralHorizontalRolloff_Z(inout float4 inVertexOS, inout float3 normalOS, float4 tangentOS, float3 pivotPoint, float3 rotationCenter, float bendAngle, float bendMinimumlRadius, float rolloff)
{
	float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	float3 normalWS   = CurvedWorld_ObjectToWorldNormal(normalOS);
	float3 tangentWS  = CurvedWorld_ObjectToWorldTangent(tangentOS.xyz);
	float3 binormalWS = cross(tangentWS, normalWS);


	positionWS -= pivotPoint;
	rotationCenter -= pivotPoint;

	float3 v0 = positionWS;
	float3 v1 = v0 + tangentWS;
	float3 v2 = v0 + binormalWS;
	 

	float3 rotationCenter2 = float3(rotationCenter.xy, rotationCenter.z + rolloff);	

    rotationCenter.z -= rolloff;

		
	float radius = abs(rotationCenter.x) < bendMinimumlRadius.x ? bendMinimumlRadius.x * CurvedWorld_Sign(rotationCenter.x) : rotationCenter.x;
			
	float angle = bendAngle.x * CurvedWorld_Sign(radius);
	float l = 6.28318530717 * radius * (angle / 360);


	float3 absZ = abs(rotationCenter.zzz - float3(v0.z, v1.z, v2.z)) / l;
	float3 smoothAbsZ = CurvedWorld_Smooth(absZ);

	float3 absZ_2 = abs(rotationCenter2.zzz - float3(v0.z, v1.z, v2.z)) / l;
	float3 smoothAbsZ_2 = CurvedWorld_Smooth(absZ_2);


	if(v0.z < rotationCenter.z)
	{
		rotationCenter.x = radius;
		Spiral_H_Rotate_Z_Negative(v0, rotationCenter, absZ.x, smoothAbsZ.x, l, angle);
	}
	else if(v0.z > rotationCenter2.z)
	{
		rotationCenter2.x = radius;
		Spiral_H_Rotate_Z_Positive(v0, rotationCenter2, absZ_2.x, smoothAbsZ_2.x, l, angle);
	}

	if(v1.z < rotationCenter.z)
	{
		rotationCenter.x = radius;
		Spiral_H_Rotate_Z_Negative(v1, rotationCenter, absZ.y, smoothAbsZ.y, l, angle);
	}
	else if(v1.z > rotationCenter2.z)
	{
		rotationCenter2.x = radius;
		Spiral_H_Rotate_Z_Positive(v1, rotationCenter2, absZ_2.y, smoothAbsZ_2.y, l, angle);
	}

	if(v2.z < rotationCenter.z)
	{
		rotationCenter.x = radius;
		Spiral_H_Rotate_Z_Negative(v2, rotationCenter, absZ.z, smoothAbsZ.z, l, angle);
	} 
	else if(v2.z > rotationCenter2.z)
	{
		rotationCenter2.x = radius;
		Spiral_H_Rotate_Z_Positive(v2, rotationCenter2, absZ_2.z, smoothAbsZ_2.z, l, angle);
	}


	v0 += pivotPoint;
	v1 += pivotPoint;
	v2 += pivotPoint;

	inVertexOS.xyz = CurvedWorld_WorldToObject(float4(v0, 1), 1);

	normalOS = CurvedWorld_WorldToObjectNormal(normalize(cross(v2 - v0, v1 - v0)));
}

////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                             Spiral Vertical                                //
//                                                                            //
//////////////////////////////////////////////////////////////////////////////// 
void CurvedWorld_SpiralVertical_X_Positive(inout float4 inVertexOS, float3 pivotPoint, float3 rotationCenter, float bendAngle, float bendMinimumlRadius)
{
    float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	
	positionWS -= pivotPoint;
	rotationCenter -= pivotPoint;
 
	if(positionWS.x > rotationCenter.x)
	{
		rotationCenter.y = abs(rotationCenter.y) < bendMinimumlRadius.x ? bendMinimumlRadius.x * CurvedWorld_Sign(rotationCenter.y) : rotationCenter.y;
		float radius = rotationCenter.y;

		float angle = bendAngle.x * CurvedWorld_Sign(radius);
		float l = 6.28318530717 * radius * (angle / 360);

		float absX = abs(rotationCenter.x - positionWS.x) / l;
		float smoothAbsX = CurvedWorld_Smooth(absX);
				

		Spiral_V_Rotate_X_Negative(positionWS, rotationCenter, absX, smoothAbsX, l, angle);
	}

	
	positionWS += pivotPoint;
	
	inVertexOS.xyz = CurvedWorld_WorldToObject(float4(positionWS, 1), 1);
}
 
void CurvedWorld_SpiralVertical_X_Positive(inout float4 inVertexOS, inout float3 normalOS, float4 tangentOS, float3 pivotPoint, float3 rotationCenter, float bendAngle, float bendMinimumlRadius)
{
	float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	float3 normalWS   = CurvedWorld_ObjectToWorldNormal(normalOS);
	float3 tangentWS  = CurvedWorld_ObjectToWorldTangent(tangentOS.xyz);
	float3 binormalWS = cross(tangentWS, normalWS);


	positionWS -= pivotPoint;
	rotationCenter -= pivotPoint;

	float3 v0 = positionWS;
	float3 v1 = v0 + tangentWS;
	float3 v2 = v0 + binormalWS;
	 

	rotationCenter.y = abs(rotationCenter.y) < bendMinimumlRadius.x ? bendMinimumlRadius.x * CurvedWorld_Sign(rotationCenter.y) : rotationCenter.y;
	float radius = rotationCenter.y;

	float angle = bendAngle.x * CurvedWorld_Sign(radius);
	float l = 6.28318530717 * radius * (angle / 360);

	float3 absX = abs(rotationCenter.xxx - float3(v0.x, v1.x, v2.x)) / l;
	float3 smoothAbsX = CurvedWorld_Smooth(absX);


	if(v0.x > rotationCenter.x)
	{
		Spiral_V_Rotate_X_Negative(v0, rotationCenter, absX.x, smoothAbsX.x, l, angle);
	}
	if(v1.x > rotationCenter.x)
	{
		Spiral_V_Rotate_X_Negative(v1, rotationCenter, absX.y, smoothAbsX.y, l, angle);
	}
	if(v2.x > rotationCenter.x)
	{
		Spiral_V_Rotate_X_Negative(v2, rotationCenter, absX.z, smoothAbsX.z, l, angle);
	}


	v0 += pivotPoint;
	v1 += pivotPoint;
	v2 += pivotPoint;

	inVertexOS.xyz = CurvedWorld_WorldToObject(float4(v0, 1), 1);

	normalOS = CurvedWorld_WorldToObjectNormal(normalize(cross(v2 - v0, v1 - v0)));
}

void CurvedWorld_SpiralVertical_X_Negative(inout float4 inVertexOS, float3 pivotPoint, float3 rotationCenter, float bendAngle, float bendMinimumlRadius)
{
    float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	

	positionWS -= pivotPoint;
	rotationCenter -= pivotPoint;

	if(positionWS.x < rotationCenter.x)
	{
		rotationCenter.y = abs(rotationCenter.y) < bendMinimumlRadius.x ? bendMinimumlRadius.x * CurvedWorld_Sign(rotationCenter.y) : rotationCenter.y;
		float radius = rotationCenter.y;

		float angle = bendAngle.x * CurvedWorld_Sign(radius);
		float l = 6.28318530717 * radius * (angle / 360);

		float absX = abs(rotationCenter.x - positionWS.x) / l;
		float smoothAbsX = CurvedWorld_Smooth(absX);


		Spiral_V_Rotate_X_Positive(positionWS, rotationCenter, absX, smoothAbsX, l, angle);
	}

	
	positionWS += pivotPoint;

	inVertexOS.xyz = CurvedWorld_WorldToObject(float4(positionWS, 1), 1);
}
 
void CurvedWorld_SpiralVertical_X_Negative(inout float4 inVertexOS, inout float3 normalOS, float4 tangentOS, float3 pivotPoint, float3 rotationCenter, float bendAngle, float bendMinimumlRadius)
{
	float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	float3 normalWS   = CurvedWorld_ObjectToWorldNormal(normalOS);
	float3 tangentWS  = CurvedWorld_ObjectToWorldTangent(tangentOS.xyz);
	float3 binormalWS = cross(tangentWS, normalWS);


	positionWS -= pivotPoint;
	rotationCenter -= pivotPoint;

	float3 v0 = positionWS;
	float3 v1 = v0 + tangentWS;
	float3 v2 = v0 + binormalWS;


	rotationCenter.y = abs(rotationCenter.y) < bendMinimumlRadius.x ? bendMinimumlRadius.x * CurvedWorld_Sign(rotationCenter.y) : rotationCenter.y;
	float radius = rotationCenter.y;

	float angle = bendAngle.x * CurvedWorld_Sign(radius);
	float l = 6.28318530717 * radius * (angle / 360);

	float3 absX = abs(rotationCenter.xxx - float3(v0.x, v1.x, v2.x)) / l;
	float3 smoothAbsX = CurvedWorld_Smooth(absX);


	if(v0.x < rotationCenter.x)
	{
		Spiral_V_Rotate_X_Positive(v0, rotationCenter, absX.x, smoothAbsX.x, l, angle);
	}
	if(v1.x < rotationCenter.x)
	{
		Spiral_V_Rotate_X_Positive(v1, rotationCenter, absX.y, smoothAbsX.y, l, angle);
	}
	if(v2.x < rotationCenter.x)
	{
		Spiral_V_Rotate_X_Positive(v2, rotationCenter, absX.z, smoothAbsX.z, l, angle);
	}


	v0 += pivotPoint;
	v1 += pivotPoint;
	v2 += pivotPoint;

	inVertexOS.xyz = CurvedWorld_WorldToObject(float4(v0, 1), 1);

	normalOS = CurvedWorld_WorldToObjectNormal(normalize(cross(v2 - v0, v1 - v0)));
}

void CurvedWorld_SpiralVertical_Z_Positive(inout float4 inVertexOS, float3 pivotPoint, float3 rotationCenter, float bendAngle, float bendMinimumlRadius)
{
    float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	

	positionWS -= pivotPoint;
	rotationCenter -= pivotPoint;

	if(positionWS.z > rotationCenter.z)
	{
		rotationCenter.y = abs(rotationCenter.y) < bendMinimumlRadius.x ? bendMinimumlRadius.x * CurvedWorld_Sign(rotationCenter.y) : rotationCenter.y;
		float radius = rotationCenter.y;

		float angle = bendAngle.x * CurvedWorld_Sign(radius);
		float l = 6.28318530717 * radius * (angle / 360);

		float absZ = abs(rotationCenter.z - positionWS.z) / l;
		float smoothAbsZ = CurvedWorld_Smooth(absZ);


		Spiral_V_Rotate_Z_Positive(positionWS, rotationCenter, absZ, smoothAbsZ, l, angle);
	}

	
	positionWS += pivotPoint;

	inVertexOS.xyz = CurvedWorld_WorldToObject(float4(positionWS, 1), 1);
}
 
void CurvedWorld_SpiralVertical_Z_Positive(inout float4 inVertexOS, inout float3 normalOS, float4 tangentOS, float3 pivotPoint, float3 rotationCenter, float bendAngle, float bendMinimumlRadius)
{
	float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	float3 normalWS   = CurvedWorld_ObjectToWorldNormal(normalOS);
	float3 tangentWS  = CurvedWorld_ObjectToWorldTangent(tangentOS.xyz);
	float3 binormalWS = cross(tangentWS, normalWS);


	positionWS -= pivotPoint;
	rotationCenter -= pivotPoint;

	float3 v0 = positionWS;
	float3 v1 = v0 + tangentWS;
	float3 v2 = v0 + binormalWS;
	 

	rotationCenter.y = abs(rotationCenter.y) < bendMinimumlRadius.x ? bendMinimumlRadius.x * CurvedWorld_Sign(rotationCenter.y) : rotationCenter.y;
	float radius = rotationCenter.y;

	float angle = bendAngle.x * CurvedWorld_Sign(radius);
	float l = 6.28318530717 * radius * (angle / 360);

	float3 absZ = abs(rotationCenter.zzz - float3(v0.z, v1.z, v2.z)) / l;
	float3 smoothAbsX = CurvedWorld_Smooth(absZ);


	if(v0.z > rotationCenter.z)
	{
		Spiral_V_Rotate_Z_Positive(v0, rotationCenter, absZ.x, smoothAbsX.x, l, angle);
	}
	if(v1.z > rotationCenter.z)
	{
		Spiral_V_Rotate_Z_Positive(v1, rotationCenter, absZ.y, smoothAbsX.y, l, angle);
	}
	if(v2.z > rotationCenter.z)
	{
		Spiral_V_Rotate_Z_Positive(v2, rotationCenter, absZ.z, smoothAbsX.z, l, angle);
	}


	v0 += pivotPoint;
	v1 += pivotPoint;
	v2 += pivotPoint;

	inVertexOS.xyz = CurvedWorld_WorldToObject(float4(v0, 1), 1);

	normalOS = CurvedWorld_WorldToObjectNormal(normalize(cross(v2 - v0, v1 - v0)));
}

void CurvedWorld_SpiralVertical_Z_Negative(inout float4 inVertexOS, float3 pivotPoint, float3 rotationCenter, float bendAngle, float bendMinimumlRadius)
{
    float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	

	positionWS -= pivotPoint;
	rotationCenter -= pivotPoint;

	if(positionWS.z < rotationCenter.z)
	{
		rotationCenter.y = abs(rotationCenter.y) < bendMinimumlRadius.x ? bendMinimumlRadius.x * CurvedWorld_Sign(rotationCenter.y) : rotationCenter.y;
		float radius = rotationCenter.y;

		float angle = bendAngle.x * CurvedWorld_Sign(radius);
		float l = 6.28318530717 * radius * (angle / 360);

		float absZ = abs(rotationCenter.z - positionWS.z) / l;
		float smoothAbsZ = CurvedWorld_Smooth(absZ);


		Spiral_V_Rotate_Z_Negative(positionWS, rotationCenter, absZ, smoothAbsZ, l, angle);
	}

	
	positionWS += pivotPoint;
	
	inVertexOS.xyz = CurvedWorld_WorldToObject(float4(positionWS, 1), 1);
}
	
void CurvedWorld_SpiralVertical_Z_Negative(inout float4 inVertexOS, inout float3 normalOS, float4 tangentOS, float3 pivotPoint, float3 rotationCenter, float bendAngle, float bendMinimumlRadius)
{
	float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	float3 normalWS   = CurvedWorld_ObjectToWorldNormal(normalOS);
	float3 tangentWS  = CurvedWorld_ObjectToWorldTangent(tangentOS.xyz);
	float3 binormalWS = cross(tangentWS, normalWS);


	positionWS -= pivotPoint;
	rotationCenter -= pivotPoint;

	float3 v0 = positionWS;
	float3 v1 = v0 + tangentWS;
	float3 v2 = v0 + binormalWS;
	 

	rotationCenter.y = abs(rotationCenter.y) < bendMinimumlRadius.x ? bendMinimumlRadius.x * CurvedWorld_Sign(rotationCenter.y) : rotationCenter.y;
	float radius = rotationCenter.y;

	float angle = bendAngle.x * CurvedWorld_Sign(radius);
	float l = 6.28318530717 * radius * (angle / 360);

	float3 absZ = abs(rotationCenter.zzz - float3(v0.z, v1.z, v2.z)) / l;
	float3 smoothAbsX = CurvedWorld_Smooth(absZ);

	if(v0.z < rotationCenter.z)
	{
		Spiral_V_Rotate_Z_Negative(v0, rotationCenter, absZ.x, smoothAbsX.x, l, angle);
	}
	if(v1.z < rotationCenter.z)
	{
		Spiral_V_Rotate_Z_Negative(v1, rotationCenter, absZ.y, smoothAbsX.y, l, angle);
	}
	if(v2.z < rotationCenter.z)
	{
		Spiral_V_Rotate_Z_Negative(v2, rotationCenter, absZ.z, smoothAbsX.z, l, angle);
	}


	v0 += pivotPoint;
	v1 += pivotPoint;
	v2 += pivotPoint;

	inVertexOS.xyz = CurvedWorld_WorldToObject(float4(v0, 1), 1);

	normalOS = CurvedWorld_WorldToObjectNormal(normalize(cross(v2 - v0, v1 - v0)));
}

////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                         Spiral Vertical  Double                            //
//                                                                            //
//////////////////////////////////////////////////////////////////////////////// 
void CurvedWorld_SpiralVerticalDouble_X(inout float4 inVertexOS, float3 pivotPoint, float3 rotationCenter, float3 rotationCenter2, float2 bendAngle, float2 bendMinimumlRadius)
{
    float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	

	positionWS -= pivotPoint;
	rotationCenter -= pivotPoint;
	rotationCenter2 -= pivotPoint;

	float2 p = float2(rotationCenter.y, rotationCenter2.y);
	float2 radius = abs(p) < bendMinimumlRadius ? bendMinimumlRadius * CurvedWorld_Sign(p) : p;
	float2 angle = bendAngle * CurvedWorld_Sign(radius);
	float2 l = 6.28318530717 * radius * (angle / 360);
	float2 absX = abs(float2(rotationCenter.x, rotationCenter2.x) - positionWS.xx) / l;
	float2 smoothAbsX = CurvedWorld_Smooth(absX);

	if(positionWS.x < rotationCenter.x)
	{
		rotationCenter.y = radius.x;

		Spiral_V_Rotate_X_Positive(positionWS, rotationCenter, absX.x, smoothAbsX.x, l.x, angle.x);
	}
	else if(positionWS.x > rotationCenter2.x)
	{
		rotationCenter2.y = radius.y;								

		Spiral_V_Rotate_X_Negative(positionWS, rotationCenter2, absX.y, smoothAbsX.y, l.y, angle.y);
	}

	
	positionWS += pivotPoint;
	
	inVertexOS.xyz = CurvedWorld_WorldToObject(float4(positionWS, 1), 1);
}
 
void CurvedWorld_SpiralVerticalDouble_X(inout float4 inVertexOS, inout float3 normalOS, float4 tangentOS, float3 pivotPoint, float3 rotationCenter, float3 rotationCenter2, float2 bendAngle, float2 bendMinimumlRadius)
{
	float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	float3 normalWS   = CurvedWorld_ObjectToWorldNormal(normalOS);
	float3 tangentWS  = CurvedWorld_ObjectToWorldTangent(tangentOS.xyz);
	float3 binormalWS = cross(tangentWS, normalWS);


	positionWS -= pivotPoint;
	rotationCenter -= pivotPoint;
	rotationCenter2 -= pivotPoint;

	float3 v0 = positionWS;
	float3 v1 = v0 + tangentWS;
	float3 v2 = v0 + binormalWS;
	 

	float2 p = float2(rotationCenter.y, rotationCenter2.y);
	float2 radius = abs(p) < bendMinimumlRadius ? bendMinimumlRadius * CurvedWorld_Sign(p) : p;			

	float2 angle = bendAngle * CurvedWorld_Sign(radius);
	float2 l = 6.28318530717 * radius * (angle / 360);


	float3 absX = abs(rotationCenter.xxx - float3(v0.x, v1.x, v2.x)) / l.x;
	float3 smoothAbsX = CurvedWorld_Smooth(absX);

	float3 absX_2 = abs(rotationCenter2.xxx - float3(v0.x, v1.x, v2.x)) / l.y;
	float3 smoothAbsX_2 = CurvedWorld_Smooth(absX_2);


	if(v0.x < rotationCenter.x)
	{
		rotationCenter.y = radius.x;
		Spiral_V_Rotate_X_Positive(v0, rotationCenter, absX.x, smoothAbsX.x, l.x, angle.x);
	}
	else if(v0.x > rotationCenter2.x)
	{
		rotationCenter2.y = radius.y;
		Spiral_V_Rotate_X_Negative(v0, rotationCenter2, absX_2.x, smoothAbsX_2.x, l.y, angle.y);
	}

	if(v1.x < rotationCenter.x)
	{
		rotationCenter.y = radius.x;
		Spiral_V_Rotate_X_Positive(v1, rotationCenter, absX.y, smoothAbsX.y, l.x, angle.x);
	}
	else if(v1.x > rotationCenter2.x)
	{
		rotationCenter2.y = radius.y;
		Spiral_V_Rotate_X_Negative(v1, rotationCenter2, absX_2.y, smoothAbsX_2.y, l.y, angle.y);
	}

	if(v2.x < rotationCenter.x)
	{
		rotationCenter.y = radius.x;
		Spiral_V_Rotate_X_Positive(v2, rotationCenter, absX.z, smoothAbsX.z, l.x, angle.x);
	}
	else if(v2.x > rotationCenter2.x)
	{
		rotationCenter2.y = radius.y;
		Spiral_V_Rotate_X_Negative(v2, rotationCenter2, absX_2.z, smoothAbsX_2.z, l.y, angle.y);
	}


	v0 += pivotPoint;
	v1 += pivotPoint;
	v2 += pivotPoint;

	inVertexOS.xyz = CurvedWorld_WorldToObject(float4(v0, 1), 1);

	normalOS = CurvedWorld_WorldToObjectNormal(normalize(cross(v2 - v0, v1 - v0)));
}

void CurvedWorld_SpiralVerticalDouble_Z(inout float4 inVertexOS, float3 pivotPoint, float3 rotationCenter, float3 rotationCenter2, float2 bendAngle, float2 bendMinimumlRadius)
{
    float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	

	positionWS -= pivotPoint;
	rotationCenter -= pivotPoint;
	rotationCenter2 -= pivotPoint;

	float2 p = float2(rotationCenter.y, rotationCenter2.y);
	float2 radius = abs(p) < bendMinimumlRadius ? bendMinimumlRadius * CurvedWorld_Sign(p) : p;
	float2 angle = bendAngle * CurvedWorld_Sign(radius);
	float2 l = 6.28318530717 * radius * (angle / 360);
	float2 absZ = abs(float2(rotationCenter.z, rotationCenter2.z) - positionWS.zz) / l;
	float2 smoothAbsZ = CurvedWorld_Smooth(absZ);

	if(positionWS.z < rotationCenter.z)
	{
		rotationCenter.y = radius.x;

		Spiral_V_Rotate_Z_Negative(positionWS, rotationCenter, absZ.x, smoothAbsZ.x, l.x, angle.x);
	}
	else if(positionWS.z > rotationCenter2.z)
	{
		rotationCenter2.y = radius.y;

		Spiral_V_Rotate_Z_Positive(positionWS, rotationCenter2, absZ.y, smoothAbsZ.y, l.y, angle.y);
	}

	
	positionWS += pivotPoint;

	inVertexOS.xyz = CurvedWorld_WorldToObject(float4(positionWS, 1), 1);
}
 
void CurvedWorld_SpiralVerticalDouble_Z(inout float4 inVertexOS, inout float3 normalOS, float4 tangentOS, float3 pivotPoint, float3 rotationCenter, float3 rotationCenter2, float2 bendAngle, float2 bendMinimumlRadius)
{
	float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	float3 normalWS   = CurvedWorld_ObjectToWorldNormal(normalOS);
	float3 tangentWS  = CurvedWorld_ObjectToWorldTangent(tangentOS.xyz);
	float3 binormalWS = cross(tangentWS, normalWS);


	positionWS -= pivotPoint;
	rotationCenter -= pivotPoint;
	rotationCenter2 -= pivotPoint;

	float3 v0 = positionWS;
	float3 v1 = v0 + tangentWS;
	float3 v2 = v0 + binormalWS;
	 

	float2 p = float2(rotationCenter.y, rotationCenter2.y);
	float2 radius = abs(p) < bendMinimumlRadius ? bendMinimumlRadius * CurvedWorld_Sign(p) : p;
	
	float2 angle = bendAngle * CurvedWorld_Sign(radius);
	float2 l = 6.28318530717 * radius * (angle / 360);


	float3 absZ = abs(rotationCenter.zzz - float3(v0.z, v1.z, v2.z)) / l.x;
	float3 smoothAbsX = CurvedWorld_Smooth(absZ);

	float3 absZ_2 = abs(rotationCenter2.zzz - float3(v0.z, v1.z, v2.z)) / l.y;
	float3 smoothAbsX_2 = CurvedWorld_Smooth(absZ_2);


	if(v0.z < rotationCenter.z)
	{
		rotationCenter.y = radius.x;
		Spiral_V_Rotate_Z_Negative(v0, rotationCenter, absZ.x, smoothAbsX.x, l.x, angle.x);
	}
	else if(v0.z > rotationCenter2.z)
	{
		rotationCenter2.y = radius.y;
		Spiral_V_Rotate_Z_Positive(v0, rotationCenter2, absZ_2.x, smoothAbsX_2.x, l.y, angle.y);
	}

	if(v1.z < rotationCenter.z)
	{
		rotationCenter.y = radius.x;
		Spiral_V_Rotate_Z_Negative(v1, rotationCenter, absZ.y, smoothAbsX.y, l.x, angle.x);
	}
	else if(v1.z > rotationCenter2.z)
	{
		rotationCenter2.y = radius.y;
		Spiral_V_Rotate_Z_Positive(v1, rotationCenter2, absZ_2.y, smoothAbsX_2.y, l.y, angle.y);
	}

	if(v2.z < rotationCenter.z)
	{
		rotationCenter.y = radius.x;
		Spiral_V_Rotate_Z_Negative(v2, rotationCenter, absZ.z, smoothAbsX.z, l.x, angle.x);
	}
	else if(v2.z > rotationCenter2.z)
	{
		rotationCenter2.y = radius.y;
		Spiral_V_Rotate_Z_Positive(v2, rotationCenter2, absZ_2.z, smoothAbsX_2.z, l.y, angle.y);
	}


	v0 += pivotPoint;
	v1 += pivotPoint;
	v2 += pivotPoint;

	inVertexOS.xyz = CurvedWorld_WorldToObject(float4(v0, 1), 1);

	normalOS = CurvedWorld_WorldToObjectNormal(normalize(cross(v2 - v0, v1 - v0)));
}

////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                         Spiral Vertical Rolloff                            //
//                                                                            //
//////////////////////////////////////////////////////////////////////////////// 
void CurvedWorld_SpiralVerticalRolloff_X(inout float4 inVertexOS, float3 pivotPoint, float3 rotationCenter, float bendAngle, float bendMinimumlRadius, float rolloff)
{
    float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	

	positionWS -= pivotPoint;
	rotationCenter -= pivotPoint;

	float3 rotationCenter2 = float3(rotationCenter.x + rolloff, rotationCenter.yz);	

	rotationCenter.x -= rolloff;

			   			
	float radius = abs(rotationCenter.y) < bendMinimumlRadius.x ? bendMinimumlRadius.x * CurvedWorld_Sign(rotationCenter.y) : rotationCenter.y;
	float angle = bendAngle.x * CurvedWorld_Sign(radius);
	float l = 6.28318530717 * radius * (angle / 360);
	float2 absX = abs(float2(rotationCenter.x, rotationCenter2.x) - positionWS.xx) / l;
	float2 smoothAbsX = CurvedWorld_Smooth(absX);

	if(positionWS.x < rotationCenter.x)
	{
		rotationCenter.y = radius;

		Spiral_V_Rotate_X_Positive(positionWS, rotationCenter, absX.x, smoothAbsX.x, l, angle);
	}
	else if(positionWS.x > rotationCenter2.x)
	{
		rotationCenter2.y = radius;								

		Spiral_V_Rotate_X_Negative(positionWS, rotationCenter2, absX.y, smoothAbsX.y, l, angle);
	}


	positionWS += pivotPoint;
	
	inVertexOS.xyz = CurvedWorld_WorldToObject(float4(positionWS, 1), 1);
}
 
void CurvedWorld_SpiralVerticalRolloff_X(inout float4 inVertexOS, inout float3 normalOS, float4 tangentOS, float3 pivotPoint, float3 rotationCenter, float bendAngle, float bendMinimumlRadius, float rolloff)
{
	float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	float3 normalWS   = CurvedWorld_ObjectToWorldNormal(normalOS);
	float3 tangentWS  = CurvedWorld_ObjectToWorldTangent(tangentOS.xyz);
	float3 binormalWS = cross(tangentWS, normalWS);


	positionWS -= pivotPoint;
	rotationCenter -= pivotPoint;

	float3 v0 = positionWS;
	float3 v1 = v0 + tangentWS;
	float3 v2 = v0 + binormalWS;
	 

	float3 rotationCenter2 = float3(rotationCenter.x + rolloff, rotationCenter.yz);

	rotationCenter.x -= rolloff;

				
	float radius = abs(rotationCenter.y) < bendMinimumlRadius.x ? bendMinimumlRadius.x * CurvedWorld_Sign(rotationCenter.y) : rotationCenter.y;			

	float angle = bendAngle.x * CurvedWorld_Sign(radius);
	float l = 6.28318530717 * radius * (angle / 360);


	float3 absX = abs(rotationCenter.xxx - float3(v0.x, v1.x, v2.x)) / l;
	float3 smoothAbsX = CurvedWorld_Smooth(absX);

	float3 absX_2 = abs(rotationCenter2.xxx - float3(v0.x, v1.x, v2.x)) / l;
	float3 smoothAbsX_2 = CurvedWorld_Smooth(absX_2);


	if(v0.x < rotationCenter.x)
	{
		rotationCenter.y = radius;
		Spiral_V_Rotate_X_Positive(v0, rotationCenter, absX.x, smoothAbsX.x, l, angle);
	}
	else if(v0.x > rotationCenter2.x)
	{
		rotationCenter2.y = radius;
		Spiral_V_Rotate_X_Negative(v0, rotationCenter2, absX_2.x, smoothAbsX_2.x, l, angle);
	}

	if(v1.x < rotationCenter.x)
	{
		rotationCenter.y = radius;
		Spiral_V_Rotate_X_Positive(v1, rotationCenter, absX.y, smoothAbsX.y, l, angle);
	}
	else if(v1.x > rotationCenter2.x)
	{
		rotationCenter2.y = radius;
		Spiral_V_Rotate_X_Negative(v1, rotationCenter2, absX_2.y, smoothAbsX_2.y, l, angle);
	}

	if(v2.x < rotationCenter.x)
	{
		rotationCenter.y = radius;
		Spiral_V_Rotate_X_Positive(v2, rotationCenter, absX.z, smoothAbsX.z, l, angle);
	}
	else if(v2.x > rotationCenter2.x)
	{
		rotationCenter2.y = radius;
		Spiral_V_Rotate_X_Negative(v2, rotationCenter2, absX_2.z, smoothAbsX_2.z, l, angle);
	}


	v0 += pivotPoint;
	v1 += pivotPoint;
	v2 += pivotPoint;

	inVertexOS.xyz = CurvedWorld_WorldToObject(float4(v0, 1), 1);

	normalOS = CurvedWorld_WorldToObjectNormal(normalize(cross(v2 - v0, v1 - v0)));
}

void CurvedWorld_SpiralVerticalRolloff_Z(inout float4 inVertexOS, float3 pivotPoint, float3 rotationCenter, float bendAngle, float bendMinimumlRadius, float rolloff)
{
    float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	

	positionWS -= pivotPoint;
	rotationCenter -= pivotPoint;

	float3 rotationCenter2 = float3(rotationCenter.xy, rotationCenter.z + rolloff);	

	rotationCenter.z -= rolloff;


	float radius = abs(rotationCenter.y) < bendMinimumlRadius.x ? bendMinimumlRadius.x * CurvedWorld_Sign(rotationCenter.y) : rotationCenter.y;
	float angle = bendAngle.x * CurvedWorld_Sign(radius);
	float l = 6.28318530717 * radius * (angle / 360);
	float2 absZ = abs(float2(rotationCenter.z, rotationCenter2.z) - positionWS.zz) / l;
	float2 smoothAbsZ = CurvedWorld_Smooth(absZ);

	if(positionWS.z < rotationCenter.z)
	{
		rotationCenter.y = radius;

		Spiral_V_Rotate_Z_Negative(positionWS, rotationCenter, absZ.x, smoothAbsZ.x, l, angle);
	}
	else if(positionWS.z > rotationCenter2.z)
	{
		rotationCenter2.y = radius;

		Spiral_V_Rotate_Z_Positive(positionWS, rotationCenter2, absZ.y, smoothAbsZ.y, l, angle);
	}

	
	positionWS += pivotPoint;
	
	inVertexOS.xyz = CurvedWorld_WorldToObject(float4(positionWS, 1), 1);
}
 
void CurvedWorld_SpiralVerticalRolloff_Z(inout float4 inVertexOS, inout float3 normalOS, float4 tangentOS, float3 pivotPoint, float3 rotationCenter, float bendAngle, float bendMinimumlRadius, float rolloff)
{
	float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
	float3 normalWS   = CurvedWorld_ObjectToWorldNormal(normalOS);
	float3 tangentWS  = CurvedWorld_ObjectToWorldTangent(tangentOS.xyz);
	float3 binormalWS = cross(tangentWS, normalWS);


	positionWS -= pivotPoint;
	rotationCenter -= pivotPoint;

	float3 v0 = positionWS;
	float3 v1 = v0 + tangentWS;
	float3 v2 = v0 + binormalWS;
	 

	float3 rotationCenter2 = float3(rotationCenter.xy, rotationCenter.z + rolloff);	

	rotationCenter.z -= rolloff;


	float radius = abs(rotationCenter.y) < bendMinimumlRadius.x ? bendMinimumlRadius.x * CurvedWorld_Sign(rotationCenter.y) : rotationCenter.y;
	
	float angle = bendAngle.x * CurvedWorld_Sign(radius);
	float l = 6.28318530717 * radius * (angle / 360);


	float3 absZ = abs(rotationCenter.zzz - float3(v0.z, v1.z, v2.z)) / l;
	float3 smoothAbsX = CurvedWorld_Smooth(absZ);

	float3 absZ_2 = abs(rotationCenter2.zzz - float3(v0.z, v1.z, v2.z)) / l;
	float3 smoothAbsX_2 = CurvedWorld_Smooth(absZ_2);


	if(v0.z < rotationCenter.z)
	{
		rotationCenter.y = radius;
		Spiral_V_Rotate_Z_Negative(v0, rotationCenter, absZ.x, smoothAbsX.x, l, angle);
	}
	else if(v0.z > rotationCenter2.z)
	{
		rotationCenter2.y = radius;
		Spiral_V_Rotate_Z_Positive(v0, rotationCenter2, absZ_2.x, smoothAbsX_2.x, l, angle);
	}

	if(v1.z < rotationCenter.z)
	{
		rotationCenter.y = radius;
		Spiral_V_Rotate_Z_Negative(v1, rotationCenter, absZ.y, smoothAbsX.y, l, angle);
	}
	else if(v1.z > rotationCenter2.z)
	{
		rotationCenter2.y = radius;
		Spiral_V_Rotate_Z_Positive(v1, rotationCenter2, absZ_2.y, smoothAbsX_2.y, l, angle);
	}

	if(v2.z < rotationCenter.z)
	{
		rotationCenter.y = radius;
		Spiral_V_Rotate_Z_Negative(v2, rotationCenter, absZ.z, smoothAbsX.z, l, angle);
	}
	else if(v2.z > rotationCenter2.z)
	{
		rotationCenter2.y = radius;
		Spiral_V_Rotate_Z_Positive(v2, rotationCenter2, absZ_2.z, smoothAbsX_2.z, l, angle);
	}


	v0 += pivotPoint;
	v1 += pivotPoint;
	v2 += pivotPoint;
	
	inVertexOS.xyz = CurvedWorld_WorldToObject(float4(v0, 1), 1);

	normalOS = CurvedWorld_WorldToObjectNormal(normalize(cross(v2 - v0, v1 - v0)));
}

////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                                Twisted Spiral                              //
//                                                                            //
//////////////////////////////////////////////////////////////////////////////// 
void CurvedWorld_TwistedSpiral_X_Positive(inout float4 inVertexOS, float3 pivotPoint, float3 rotationAxis, float3 bendSize, float3 bendOffset)
{
	float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
    positionWS -= pivotPoint;


    float d = max(0, positionWS.x - bendOffset.x);
	d = CurvedWorld_SmoothTwistedPositive(d, 100);
	float angle = bendSize.x * d;         
            
    CurvedWorld_RotateVertex(positionWS, pivotPoint, rotationAxis, angle);

    float2 offset = max(float2(0, 0), positionWS.xx - bendOffset.yz);
    offset *= offset;
    positionWS += float3(0.0f, bendSize.y * offset.x, -bendSize.z * offset.y) * 0.001;

 
    positionWS += pivotPoint;

    inVertexOS.xyz = CurvedWorld_WorldToObject(float4(positionWS, 1), 1);
}

void CurvedWorld_TwistedSpiral_X_Positive(inout float4 inVertexOS, inout float3 inNormalOS, float4 tangentOS, float3 pivotPoint, float3 rotationAxis, float3 bendSize, float3 bendOffset)
{
	float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
    float3 normalWS   = CurvedWorld_ObjectToWorldNormal(inNormalOS);
    float3 tangentWS  = CurvedWorld_ObjectToWorldTangent(tangentOS.xyz);
    float3 binormalWS = cross(tangentWS, normalWS);

    positionWS -= pivotPoint;
 

    float3 v0 = positionWS;
    float3 v1 = v0 + tangentWS;
    float3 v2 = v0 + binormalWS;


    float3 d = max(0, float3(v0.x, v1.x, v2.x) - bendOffset.xxx);
	d = CurvedWorld_SmoothTwistedPositive(d, 100);
    float3 angle = bendSize.xxx * d;               

    CurvedWorld_RotateVertex(v0, pivotPoint, rotationAxis, angle.x);
    float2 offset = max(float2(0, 0), v0.xx - bendOffset.yz);
    offset *= offset;
    v0 += float3(0.0f, bendSize.y * offset.x, -bendSize.z * offset.y) * 0.001;


    CurvedWorld_RotateVertex(v1, pivotPoint, rotationAxis, angle.y);
    offset = max(float2(0, 0), v1.xx - bendOffset.yz);
    offset *= offset;
    v1 += float3(0.0f, bendSize.y * offset.x, -bendSize.z * offset.y) * 0.001;
      

    CurvedWorld_RotateVertex(v2, pivotPoint, rotationAxis, angle.z);
    offset = max(float2(0, 0), v2.xx - bendOffset.yz);
    offset *= offset;
    v2 += float3(0.0f, bendSize.y * offset.x, -bendSize.z * offset.y) * 0.001;



    v0 += pivotPoint;
    v1 += pivotPoint;
    v2 += pivotPoint;

    inVertexOS.xyz = CurvedWorld_WorldToObject(float4(v0, 1), 1);

    inNormalOS = CurvedWorld_WorldToObjectNormal(normalize(cross(v2 - v0, v1 - v0)));
}

void CurvedWorld_TwistedSpiral_X_Negative(inout float4 inVertexOS, float3 pivotPoint, float3 rotationAxis, float3 bendSize, float3 bendOffset)
{
	float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
    positionWS -= pivotPoint;


    float d = min(0, positionWS.x + bendOffset.x);
	d = CurvedWorld_SmoothTwistedNegative(d, -100);
    float angle = bendSize.x * d;         
            
    CurvedWorld_RotateVertex(positionWS, pivotPoint, rotationAxis, angle);


    float2 offset = min(float2(0, 0), positionWS.xx + bendOffset.yz);
    offset *= offset;
    positionWS += float3(0.0f, bendSize.y * offset.x, bendSize.z * offset.y) * 0.001;



    positionWS += pivotPoint;

    inVertexOS.xyz = CurvedWorld_WorldToObject(float4(positionWS, 1), 1);
}

void CurvedWorld_TwistedSpiral_X_Negative(inout float4 inVertexOS, inout float3 inNormalOS, float4 tangentOS, float3 pivotPoint, float3 rotationAxis, float3 bendSize, float3 bendOffset)
{
	float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
    float3 normalWS   = CurvedWorld_ObjectToWorldNormal(inNormalOS);
    float3 tangentWS  = CurvedWorld_ObjectToWorldTangent(tangentOS.xyz);
    float3 binormalWS = cross(tangentWS, normalWS);

    positionWS -= pivotPoint;


    float3 v0 = positionWS;
    float3 v1 = v0 + tangentWS;
    float3 v2 = v0 + binormalWS;


    float3 d = min(0, float3(v0.x, v1.x, v2.x) + bendOffset.xxx);
	d = CurvedWorld_SmoothTwistedNegative(d, -100);
    float3 angle = bendSize.xxx * d;         
            

    CurvedWorld_RotateVertex(v0, pivotPoint, rotationAxis, angle.x);
    float2 offset = min(float2(0, 0), v0.xx + bendOffset.yz);
    offset *= offset;
    v0 += float3(0.0f, bendSize.y * offset.x, bendSize.z * offset.y) * 0.001;


    CurvedWorld_RotateVertex(v1, pivotPoint, rotationAxis, angle.y);
    offset = min(float2(0, 0), v1.xx + bendOffset.yz);
    offset *= offset;
    v1 += float3(0.0f, bendSize.y * offset.x, bendSize.z * offset.y) * 0.001;
      

    CurvedWorld_RotateVertex(v2, pivotPoint, rotationAxis, angle.z);
    offset = min(float2(0, 0), v2.xx + bendOffset.yz);
    offset *= offset;
    v2 += float3(0.0f, bendSize.y * offset.x, bendSize.z * offset.y) * 0.001;



    v0 += pivotPoint;
    v1 += pivotPoint;
    v2 += pivotPoint;

    inVertexOS.xyz = CurvedWorld_WorldToObject(float4(v0, 1), 1);

    inNormalOS = CurvedWorld_WorldToObjectNormal(normalize(cross(v2 - v0, v1 - v0)));
}

void CurvedWorld_TwistedSpiral_Z_Positive(inout float4 inVertexOS, float3 pivotPoint, float3 rotationAxis, float3 bendSize, float3 bendOffset)
{
	float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
    positionWS -= pivotPoint;


    float d = max(0, positionWS.z - bendOffset.x);
	d = CurvedWorld_SmoothTwistedPositive(d, 100);
    float angle = bendSize.x * d;         
            
    CurvedWorld_RotateVertex(positionWS, pivotPoint, rotationAxis, angle);


    float2 offset = max(float2(0, 0), positionWS.zz - bendOffset.yz);
    offset *= offset;
    positionWS += float3(bendSize.z * offset.y, bendSize.y * offset.x, 0.0f) * 0.001;



    positionWS += pivotPoint;

    inVertexOS.xyz = CurvedWorld_WorldToObject(float4(positionWS, 1), 1);
}

void CurvedWorld_TwistedSpiral_Z_Positive(inout float4 inVertexOS, inout float3 inNormalOS, float4 tangentOS, float3 pivotPoint, float3 rotationAxis, float3 bendSize, float3 bendOffset)
{
	float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
    float3 normalWS   = CurvedWorld_ObjectToWorldNormal(inNormalOS);
    float3 tangentWS  = CurvedWorld_ObjectToWorldTangent(tangentOS.xyz);
    float3 binormalWS = cross(tangentWS, normalWS);

    positionWS -= pivotPoint;


    float3 v0 = positionWS;
    float3 v1 = v0 + tangentWS;
    float3 v2 = v0 + binormalWS;


    float3 d = max(0, float3(v0.z, v1.z, v2.z) - bendOffset.xxx);
	d = CurvedWorld_SmoothTwistedPositive(d, 100);
    float3 angle = bendSize.xxx * d;         
            

    CurvedWorld_RotateVertex(v0, pivotPoint, rotationAxis, angle.x);
    float2 offset = max(float2(0, 0), v0.zz - bendOffset.yz);
    offset *= offset;
    v0 += float3(bendSize.z * offset.y, bendSize.y * offset.x, 0.0f) * 0.001;


    CurvedWorld_RotateVertex(v1, pivotPoint, rotationAxis, angle.y);
    offset = max(float2(0, 0), v1.zz - bendOffset.yz);
    offset *= offset;
    v1 += float3(bendSize.z * offset.y, bendSize.y * offset.x, 0.0f) * 0.001;
      

    CurvedWorld_RotateVertex(v2, pivotPoint, rotationAxis, angle.z);
    offset = max(float2(0, 0), v2.zz - bendOffset.yz);
    offset *= offset;
    v2 += float3(bendSize.z * offset.y, bendSize.y * offset.x, 0.0f) * 0.001;



    v0 += pivotPoint;
    v1 += pivotPoint;
    v2 += pivotPoint;

    inVertexOS.xyz = CurvedWorld_WorldToObject(float4(v0, 1), 1);

    inNormalOS = CurvedWorld_WorldToObjectNormal(normalize(cross(v2 - v0, v1 - v0)));
}

void CurvedWorld_TwistedSpiral_Z_Negative(inout float4 inVertexOS, float3 pivotPoint, float3 rotationAxis, float3 bendSize, float3 bendOffset)
{
	float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
    positionWS -= pivotPoint;


    float d = min(0, positionWS.z + bendOffset.x);
	d = CurvedWorld_SmoothTwistedNegative(d, -100);
    float angle = bendSize.x * d;         
            
    CurvedWorld_RotateVertex(positionWS, pivotPoint, rotationAxis, angle);


    float2 offset = min(float2(0, 0), positionWS.zz + bendOffset.yz);
    offset *= offset;
    positionWS += float3(-bendSize.z * offset.y, bendSize.y * offset.x, 0.0f) * 0.001;



    positionWS += pivotPoint;

    inVertexOS.xyz = CurvedWorld_WorldToObject(float4(positionWS, 1), 1);
}

void CurvedWorld_TwistedSpiral_Z_Negative(inout float4 inVertexOS, inout float3 inNormalOS, float4 tangentOS, float3 pivotPoint, float3 rotationAxis, float3 bendSize, float3 bendOffset)
{
	float3 positionWS = CurvedWorld_ObjectToWorld(inVertexOS);
    float3 normalWS   = CurvedWorld_ObjectToWorldNormal(inNormalOS);
    float3 tangentWS  = CurvedWorld_ObjectToWorldTangent(tangentOS.xyz);
    float3 binormalWS = cross(tangentWS, normalWS);

    positionWS -= pivotPoint;


    float3 v0 = positionWS;
    float3 v1 = v0 + tangentWS;
    float3 v2 = v0 + binormalWS;


    float3 d = min(0, float3(v0.z, v1.z, v2.z) + bendOffset.xxx);
	d = CurvedWorld_SmoothTwistedNegative(d, -100);
    float3 angle = bendSize.xxx * d;         
            

    CurvedWorld_RotateVertex(v0, pivotPoint, rotationAxis, angle.x);
    float2 offset = min(float2(0, 0), v0.zz + bendOffset.yz);
    offset *= offset;
    v0 += float3(-bendSize.z * offset.y, bendSize.y * offset.x, 0.0f) * 0.001;


    CurvedWorld_RotateVertex(v1, pivotPoint, rotationAxis, angle.y);
    offset = min(float2(0, 0), v1.zz + bendOffset.yz);
    offset *= offset;
    v1 += float3(-bendSize.z * offset.y, bendSize.y * offset.x, 0.0f) * 0.001;
      

    CurvedWorld_RotateVertex(v2, pivotPoint, rotationAxis, angle.z);
    offset = min(float2(0, 0), v2.zz + bendOffset.yz);
    offset *= offset;
    v2 += float3(-bendSize.z * offset.y, bendSize.y * offset.x, 0.0f) * 0.001;



    v0 += pivotPoint;
    v1 += pivotPoint;
    v2 += pivotPoint;

    inVertexOS.xyz = CurvedWorld_WorldToObject(float4(v0, 1), 1);

    inNormalOS = CurvedWorld_WorldToObjectNormal(normalize(cross(v2 - v0, v1 - v0)));
}
#endif