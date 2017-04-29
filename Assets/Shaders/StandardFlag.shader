﻿Shader "Unlit/StandardFlag"
{
	Properties{
		_MainTex("Albedo (RGB) Alpha (A)", 2D) = "white" {}
		_Speed("Speed", Range(0, 5.0)) = 1
		_Frequency("Frequency", Range(0, 1.3)) = 1
		_Amplitude("Amplitude", Range(0, 5.0)) = 1
	}
	SubShader{
		Tags{ "Queue" = "Transparent+10" "RenderType" = "Transparent" "IgnoreProjector" = "True" }
		Cull off
			AlphaToMask On
			AlphaTest Greater 0.5
		Pass{
			//ZWrite Off
			//Blend SrcAlpha OneMinusSrcAlpha // Traditional transparency
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			sampler2D _MainTex;
			float4 _MainTex_ST;

			struct v2f {
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float4 color : COLOR0;
			};

			float _Speed;
			float _Frequency;
			float _Amplitude;

			v2f vert(appdata_base v)
			{
				v2f o;
				v.vertex.y += cos((v.vertex.x + _Time.y * _Speed) * _Frequency) * _Amplitude * (v.vertex.x - 5);
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				return tex2D(_MainTex, i.uv);
			}


			ENDCG
		}
	}
	FallBack "Diffuse"
}
