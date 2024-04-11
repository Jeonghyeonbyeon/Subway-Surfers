using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SoundManager : MonoBehaviour
{
    public static SoundManager instance;

    [Header("-----AudioSource-----")]
    [SerializeField] private AudioSource bgmSource;
    [SerializeField] private AudioSource sfxSource;

    [Header("-----AudioClip-----")]
    public AudioClip inGameBGM;

    public AudioClip coin;
    public AudioClip itemBox;

    private void Awake()
    {
        instance = this;
    }

    private void Start() => PlayBGMLoop();

    public void PlayBGMLoop()
    {
        bgmSource.clip = inGameBGM;
        bgmSource.loop = true;
        bgmSource.Play();
    }

    public void PlaySFX(AudioClip clip)
    {
        sfxSource.PlayOneShot(clip);
    }
}
