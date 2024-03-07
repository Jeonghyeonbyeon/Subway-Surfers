Shader "Amazing Assets/Curved World/Tutorial/Unlit Shader"
{
    Properties
    {
        //Paste Curved World material property here////////////////////////////////////


        _MainTex ("Texture", 2D) = "white" {}
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass  
        {
            CGPROGRAM 
            #pragma vertex vert
            #pragma fragment frag 
            #pragma multi_compile_fog
  
            #include "UnityCG.cginc"     
 

			//Paste Curved World definitions and keywords here/////////////////////////


			sampler2D _MainTex;
            float4 _MainTex_ST;

            struct v2f 
            {
				float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                
            };

            v2f vert (appdata_full v)
            {
                v2f o;


				//Paste Curved World vertex transformation here////////////////////////


                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
				
				return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);


                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
